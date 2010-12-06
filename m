From: Josef Bacik <josef@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Mon, 6 Dec 2010 09:27:44 -0500
Message-ID: <20101206142743.GA2556@localhost.localdomain>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101203214526.GA4508@localhost.localdomain> <AANLkTimG7Qp_VCe71y7M4t5Y+x8kO=AAJWO1NWDN0HJO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com, bfields@redhat.com
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimG7Qp_VCe71y7M4t5Y+x8kO=AAJWO1NWDN0HJO@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 04, 2010 at 01:58:07PM -0800, Mike Fedyk wrote:
> On Fri, Dec 3, 2010 at 1:45 PM, Josef Bacik <josef@redhat.com> wrote:
> > On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> >> Hello,
> >>
> >> Various people have complained about how BTRFS deals with subvolum=
es recently,
> >> specifically the fact that they all have the same inode number, an=
d there's no
> >> discrete seperation from one subvolume to another. =A0Christoph as=
ked that I lay
> >> out a basic design document of how we want subvolumes to work so w=
e can hash
> >> everything out now, fix what is broken, and then move forward with=
 a design that
> >> everybody is more or less happy with. =A0I apologize in advance fo=
r how freaking
> >> long this email is going to be. =A0I assume that most people are g=
enerally
> >> familiar with how BTRFS works, so I'm not going to bother explaini=
ng in great
> >> detail some stuff.
> >>
> >> =3D=3D=3D What are subvolumes? =3D=3D=3D
> >>
> >> They are just another tree. =A0In BTRFS we have various b-trees to=
 describe the
> >> filesystem. =A0A few of them are filesystem wide, such as the exte=
nt tree, chunk
> >> tree, root tree etc. =A0The tree's that hold the actual filesystem=
 data, that is
> >> inodes and such, are kept in their own b-tree. =A0This is how subv=
olumes and
> >> snapshots appear on disk, they are simply new b-trees with all of =
the file data
> >> contained within them.
> >>
> >> =3D=3D=3D What do subvolumes look like? =3D=3D=3D
> >>
> >> All the user sees are directories. =A0They act like any other dire=
ctory acts, with
> >> a few exceptions
> >>
> >> 1) You cannot hardlink between subvolumes. =A0This is because subv=
olumes have
> >> their own inode numbers and such, think of them as seperate mounts=
 in this case,
> >> you cannot hardlink between two mounts because the link needs to p=
oint to the
> >> same on disk inode, which is impossible between two different file=
systems. =A0The
> >> same is true for subvolumes, they have their own trees with their =
own inodes and
> >> inode numbers, so it's impossible to hardlink between them.
> >>
> >> 1a) In case it wasn't clear from above, each subvolume has their o=
wn inode
> >> numbers, so you can have the same inode numbers used between two d=
ifferent
> >> subvolumes, since they are two different trees.
> >>
> >> 2) Obviously you can't just rm -rf subvolumes. =A0Because they are=
 roots there's
> >> extra metadata to keep track of them, so you have to use one of ou=
r ioctls to
> >> delete subvolumes/snapshots.
> >>
> >> But permissions and everything else they are the same.
> >>
> >> There is one tricky thing. =A0When you create a subvolume, the dir=
ectory inode
> >> that is created in the parent subvolume has the inode number of 25=
6. =A0So if you
> >> have a bunch of subvolumes in the same parent subvolume, you are g=
oing to have a
> >> bunch of directories with the inode number of 256. =A0This is so w=
hen users cd
> >> into a subvolume we can know its a subvolume and do all the normal=
 voodoo to
> >> start looking in the subvolumes tree instead of the parent subvolu=
mes tree.
> >>
> >> This is where things go a bit sideways. =A0We had serious problems=
 with NFS, but
> >> thankfully NFS gives us a bunch of hooks to get around these probl=
ems.
> >> CIFS/Samba do not, so we will have problems there, not to mention =
any other
> >> userspace application that looks at inode numbers.
> >>
> >> =3D=3D=3D How do we want subvolumes to work from a user perspectiv=
e? =3D=3D=3D
> >>
> >> 1) Users need to be able to create their own subvolumes. =A0The pe=
rmission
> >> semantics will be absolutely the same as creating directories, so =
I don't think
> >> this is too tricky. =A0We want this because you can only take snap=
shots of
> >> subvolumes, and so it is important that users be able to create th=
eir own
> >> discrete snapshottable targets.
> >>
> >> 2) Users need to be able to snapshot their subvolumes. =A0This is =
basically the
> >> same as #1, but it bears repeating.
> >>
> >> 3) Subvolumes shouldn't need to be specifically mounted. =A0This i=
s also
> >> important, we don't want users to have to go around mounting their=
 subvolumes up
> >> manually one-by-one. =A0Today users just cd into subvolumes and it=
 works, just
> >> like cd'ing into a directory.
> >>
> >> =3D=3D=3D Quotas =3D=3D=3D
> >>
> >> This is a huge topic in and of itself, but Christoph mentioned wan=
ting to have
> >> an idea of what we wanted to do with it, so I'm putting it here. =A0=
There are
> >> really 2 things here
> >>
> >> 1) Limiting the size of subvolumes. =A0This is really easy for us,=
 just create a
> >> subvolume and at creation time set a maximum size it can grow to a=
nd not let it
> >> go farther than that. =A0Nice, simple and straightforward.
> >>
> >> 2) Normal quotas, via the quota tools. =A0This just comes down to =
how do we want
> >> to charge users, do we want to do it per subvolume, or per filesys=
tem. =A0My vote
> >> is per filesystem. =A0Obviously this will make it tricky with snap=
shots, but I
> >> think if we're just charging the diff's between the original volum=
e and the
> >> snapshot to the user then that will be the easiest for people to u=
nderstand,
> >> rather than making a snapshot all of a sudden count the users curr=
ently used
> >> quota * 2.
> >>
> >> =3D=3D=3D What do we do? =3D=3D=3D
> >>
> >> This is where I expect to see the most discussion. =A0Here is what=
 I want to do
> >>
> >> 1) Scrap the 256 inode number thing. =A0Instead we'll just put a f=
lag in the inode
> >> to say "Hey, I'm a subvolume" and then we can do all of the approp=
riate magic
> >> that way. =A0This unfortunately will be an incompatible format cha=
nge, but the
> >> sooner we get this adressed the easier it will be in the long run.=
 =A0Obviously
> >> when I say format change I mean via the incompat bits we have, so =
old fs's won't
> >> be broken and such.
> >>
> >> 2) Do something like NFS's referral mounts when we cd into a subvo=
lume. =A0Now we
> >> just do dentry trickery, but that doesn't make the boundary betwee=
n subvolumes
> >> clear, so it will confuse people (and samba) when they walk into a=
 subvolume and
> >> all of a sudden the inode numbers are the same as in the directory=
 behind them.
> >> With doing the referral mount thing, each subvolume appears to be =
its own mount
> >> and that way things like NFS and samba will work properly.
> >>
> >> I feel like I'm forgetting something here, hopefully somebody will=
 point it out.
> >>
> >> =3D=3D=3D Conclusion =3D=3D=3D
> >>
> >> There are definitely some wonky things with subvolumes, but I don'=
t think they
> >> are things that cannot be fixed now. =A0Some of these changes will=
 require
> >> incompat format changes, but it's either we fix it now, or later o=
n down the
> >> road when BTRFS starts getting used in production really find out =
how many
> >> things our current scheme breaks and then have to do the changes t=
hen. =A0Thanks,
> >>
> >
> > So now that I've actually looked at everything, it looks like the s=
emantics are
> > all right for subvolumes
> >
> > 1) readdir - we return the root id in d_ino, which is unique across=
 the fs
> > 2) stat - we return 256 for all subvolumes, because that is their i=
node number
> > 3) dev_t - we setup an anon super for all volumes, so they all get =
their own
> > dev_t, which is set properly for all of their children, see below
> >
> > [root@test1244 btrfs-test]# stat .
> > =A0File: `.'
> > =A0Size: 20 =A0 =A0 =A0 =A0 =A0 =A0 =A0Blocks: 8 =A0 =A0 =A0 =A0 =A0=
IO Block: 4096 =A0 directory
> > Device: 15h/21d Inode: 256 =A0 =A0 =A0 =A0 Links: 1
> > Access: (0555/dr-xr-xr-x) =A0Uid: ( =A0 =A00/ =A0 =A0root) =A0 Gid:=
 ( =A0 =A00/ =A0 =A0root)
> > Access: 2010-12-03 15:35:41.931679393 -0500
> > Modify: 2010-12-03 15:35:20.405679493 -0500
> > Change: 2010-12-03 15:35:20.405679493 -0500
> >
> > [root@test1244 btrfs-test]# stat foo
> > =A0File: `foo'
> > =A0Size: 12 =A0 =A0 =A0 =A0 =A0 =A0 =A0Blocks: 0 =A0 =A0 =A0 =A0 =A0=
IO Block: 4096 =A0 directory
> > Device: 19h/25d Inode: 256 =A0 =A0 =A0 =A0 Links: 1
> > Access: (0700/drwx------) =A0Uid: ( =A0 =A00/ =A0 =A0root) =A0 Gid:=
 ( =A0 =A00/ =A0 =A0root)
> > Access: 2010-12-03 15:35:17.501679393 -0500
> > Modify: 2010-12-03 15:35:59.150680051 -0500
> > Change: 2010-12-03 15:35:59.150680051 -0500
> >
> > [root@test1244 btrfs-test]# stat foo/foobar
> > =A0File: `foo/foobar'
> > =A0Size: 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Blocks: 0 =A0 =A0 =A0 =A0 =A0=
IO Block: 4096 =A0 regular empty file
> > Device: 19h/25d Inode: 257 =A0 =A0 =A0 =A0 Links: 1
> > Access: (0644/-rw-r--r--) =A0Uid: ( =A0 =A00/ =A0 =A0root) =A0 Gid:=
 ( =A0 =A00/ =A0 =A0root)
> > Access: 2010-12-03 15:35:59.150680051 -0500
> > Modify: 2010-12-03 15:35:59.150680051 -0500
> > Change: 2010-12-03 15:35:59.150680051 -0500
> >
> > So as far as the user is concerned, everything should come out righ=
t. =A0Obviously
> > we had to do the NFS trickery still because as far as VFS is concer=
ned the
> > subvolumes are all on the same mount. =A0So the question is this (a=
nd really this
> > is directed at Christoph and Bruce and anybody else who may care), =
is this good
> > enough, or do we want to have a seperate vfsmount for each subvolum=
e? =A0Thanks,
> >
>=20
> What are the drawbacks of having a vfsmount for each subvolume?
>=20
> Why (besides having to code it up) are you trying to avoid doing it t=
hat way?

It's the having to code it up that way thing, I'm nothing if not lazy.

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
