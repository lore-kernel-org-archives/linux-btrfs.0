From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: What to do about subvolumes?
Date: Sat, 4 Dec 2010 13:58:07 -0800
Message-ID: <AANLkTimG7Qp_VCe71y7M4t5Y+x8kO=AAJWO1NWDN0HJO@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<20101203214526.GA4508@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com,
	bfields@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101203214526.GA4508@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 3, 2010 at 1:45 PM, Josef Bacik <josef@redhat.com> wrote:
> On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
>> Hello,
>>
>> Various people have complained about how BTRFS deals with subvolumes=
 recently,
>> specifically the fact that they all have the same inode number, and =
there's no
>> discrete seperation from one subvolume to another. =C2=A0Christoph a=
sked that I lay
>> out a basic design document of how we want subvolumes to work so we =
can hash
>> everything out now, fix what is broken, and then move forward with a=
 design that
>> everybody is more or less happy with. =C2=A0I apologize in advance f=
or how freaking
>> long this email is going to be. =C2=A0I assume that most people are =
generally
>> familiar with how BTRFS works, so I'm not going to bother explaining=
 in great
>> detail some stuff.
>>
>> =3D=3D=3D What are subvolumes? =3D=3D=3D
>>
>> They are just another tree. =C2=A0In BTRFS we have various b-trees t=
o describe the
>> filesystem. =C2=A0A few of them are filesystem wide, such as the ext=
ent tree, chunk
>> tree, root tree etc. =C2=A0The tree's that hold the actual filesyste=
m data, that is
>> inodes and such, are kept in their own b-tree. =C2=A0This is how sub=
volumes and
>> snapshots appear on disk, they are simply new b-trees with all of th=
e file data
>> contained within them.
>>
>> =3D=3D=3D What do subvolumes look like? =3D=3D=3D
>>
>> All the user sees are directories. =C2=A0They act like any other dir=
ectory acts, with
>> a few exceptions
>>
>> 1) You cannot hardlink between subvolumes. =C2=A0This is because sub=
volumes have
>> their own inode numbers and such, think of them as seperate mounts i=
n this case,
>> you cannot hardlink between two mounts because the link needs to poi=
nt to the
>> same on disk inode, which is impossible between two different filesy=
stems. =C2=A0The
>> same is true for subvolumes, they have their own trees with their ow=
n inodes and
>> inode numbers, so it's impossible to hardlink between them.
>>
>> 1a) In case it wasn't clear from above, each subvolume has their own=
 inode
>> numbers, so you can have the same inode numbers used between two dif=
ferent
>> subvolumes, since they are two different trees.
>>
>> 2) Obviously you can't just rm -rf subvolumes. =C2=A0Because they ar=
e roots there's
>> extra metadata to keep track of them, so you have to use one of our =
ioctls to
>> delete subvolumes/snapshots.
>>
>> But permissions and everything else they are the same.
>>
>> There is one tricky thing. =C2=A0When you create a subvolume, the di=
rectory inode
>> that is created in the parent subvolume has the inode number of 256.=
 =C2=A0So if you
>> have a bunch of subvolumes in the same parent subvolume, you are goi=
ng to have a
>> bunch of directories with the inode number of 256. =C2=A0This is so =
when users cd
>> into a subvolume we can know its a subvolume and do all the normal v=
oodoo to
>> start looking in the subvolumes tree instead of the parent subvolume=
s tree.
>>
>> This is where things go a bit sideways. =C2=A0We had serious problem=
s with NFS, but
>> thankfully NFS gives us a bunch of hooks to get around these problem=
s.
>> CIFS/Samba do not, so we will have problems there, not to mention an=
y other
>> userspace application that looks at inode numbers.
>>
>> =3D=3D=3D How do we want subvolumes to work from a user perspective?=
 =3D=3D=3D
>>
>> 1) Users need to be able to create their own subvolumes. =C2=A0The p=
ermission
>> semantics will be absolutely the same as creating directories, so I =
don't think
>> this is too tricky. =C2=A0We want this because you can only take sna=
pshots of
>> subvolumes, and so it is important that users be able to create thei=
r own
>> discrete snapshottable targets.
>>
>> 2) Users need to be able to snapshot their subvolumes. =C2=A0This is=
 basically the
>> same as #1, but it bears repeating.
>>
>> 3) Subvolumes shouldn't need to be specifically mounted. =C2=A0This =
is also
>> important, we don't want users to have to go around mounting their s=
ubvolumes up
>> manually one-by-one. =C2=A0Today users just cd into subvolumes and i=
t works, just
>> like cd'ing into a directory.
>>
>> =3D=3D=3D Quotas =3D=3D=3D
>>
>> This is a huge topic in and of itself, but Christoph mentioned wanti=
ng to have
>> an idea of what we wanted to do with it, so I'm putting it here. =C2=
=A0There are
>> really 2 things here
>>
>> 1) Limiting the size of subvolumes. =C2=A0This is really easy for us=
, just create a
>> subvolume and at creation time set a maximum size it can grow to and=
 not let it
>> go farther than that. =C2=A0Nice, simple and straightforward.
>>
>> 2) Normal quotas, via the quota tools. =C2=A0This just comes down to=
 how do we want
>> to charge users, do we want to do it per subvolume, or per filesyste=
m. =C2=A0My vote
>> is per filesystem. =C2=A0Obviously this will make it tricky with sna=
pshots, but I
>> think if we're just charging the diff's between the original volume =
and the
>> snapshot to the user then that will be the easiest for people to und=
erstand,
>> rather than making a snapshot all of a sudden count the users curren=
tly used
>> quota * 2.
>>
>> =3D=3D=3D What do we do? =3D=3D=3D
>>
>> This is where I expect to see the most discussion. =C2=A0Here is wha=
t I want to do
>>
>> 1) Scrap the 256 inode number thing. =C2=A0Instead we'll just put a =
flag in the inode
>> to say "Hey, I'm a subvolume" and then we can do all of the appropri=
ate magic
>> that way. =C2=A0This unfortunately will be an incompatible format ch=
ange, but the
>> sooner we get this adressed the easier it will be in the long run. =C2=
=A0Obviously
>> when I say format change I mean via the incompat bits we have, so ol=
d fs's won't
>> be broken and such.
>>
>> 2) Do something like NFS's referral mounts when we cd into a subvolu=
me. =C2=A0Now we
>> just do dentry trickery, but that doesn't make the boundary between =
subvolumes
>> clear, so it will confuse people (and samba) when they walk into a s=
ubvolume and
>> all of a sudden the inode numbers are the same as in the directory b=
ehind them.
>> With doing the referral mount thing, each subvolume appears to be it=
s own mount
>> and that way things like NFS and samba will work properly.
>>
>> I feel like I'm forgetting something here, hopefully somebody will p=
oint it out.
>>
>> =3D=3D=3D Conclusion =3D=3D=3D
>>
>> There are definitely some wonky things with subvolumes, but I don't =
think they
>> are things that cannot be fixed now. =C2=A0Some of these changes wil=
l require
>> incompat format changes, but it's either we fix it now, or later on =
down the
>> road when BTRFS starts getting used in production really find out ho=
w many
>> things our current scheme breaks and then have to do the changes the=
n. =C2=A0Thanks,
>>
>
> So now that I've actually looked at everything, it looks like the sem=
antics are
> all right for subvolumes
>
> 1) readdir - we return the root id in d_ino, which is unique across t=
he fs
> 2) stat - we return 256 for all subvolumes, because that is their ino=
de number
> 3) dev_t - we setup an anon super for all volumes, so they all get th=
eir own
> dev_t, which is set properly for all of their children, see below
>
> [root@test1244 btrfs-test]# stat .
> =C2=A0File: `.'
> =C2=A0Size: 20 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Blocks=
: 8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IO Block: 4096 =C2=A0 directory
> Device: 15h/21d Inode: 256 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Links: 1
> Access: (0555/dr-xr-xr-x) =C2=A0Uid: ( =C2=A0 =C2=A00/ =C2=A0 =C2=A0r=
oot) =C2=A0 Gid: ( =C2=A0 =C2=A00/ =C2=A0 =C2=A0root)
> Access: 2010-12-03 15:35:41.931679393 -0500
> Modify: 2010-12-03 15:35:20.405679493 -0500
> Change: 2010-12-03 15:35:20.405679493 -0500
>
> [root@test1244 btrfs-test]# stat foo
> =C2=A0File: `foo'
> =C2=A0Size: 12 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Blocks=
: 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IO Block: 4096 =C2=A0 directory
> Device: 19h/25d Inode: 256 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Links: 1
> Access: (0700/drwx------) =C2=A0Uid: ( =C2=A0 =C2=A00/ =C2=A0 =C2=A0r=
oot) =C2=A0 Gid: ( =C2=A0 =C2=A00/ =C2=A0 =C2=A0root)
> Access: 2010-12-03 15:35:17.501679393 -0500
> Modify: 2010-12-03 15:35:59.150680051 -0500
> Change: 2010-12-03 15:35:59.150680051 -0500
>
> [root@test1244 btrfs-test]# stat foo/foobar
> =C2=A0File: `foo/foobar'
> =C2=A0Size: 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Blocks=
: 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IO Block: 4096 =C2=A0 regular emp=
ty file
> Device: 19h/25d Inode: 257 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Links: 1
> Access: (0644/-rw-r--r--) =C2=A0Uid: ( =C2=A0 =C2=A00/ =C2=A0 =C2=A0r=
oot) =C2=A0 Gid: ( =C2=A0 =C2=A00/ =C2=A0 =C2=A0root)
> Access: 2010-12-03 15:35:59.150680051 -0500
> Modify: 2010-12-03 15:35:59.150680051 -0500
> Change: 2010-12-03 15:35:59.150680051 -0500
>
> So as far as the user is concerned, everything should come out right.=
 =C2=A0Obviously
> we had to do the NFS trickery still because as far as VFS is concerne=
d the
> subvolumes are all on the same mount. =C2=A0So the question is this (=
and really this
> is directed at Christoph and Bruce and anybody else who may care), is=
 this good
> enough, or do we want to have a seperate vfsmount for each subvolume?=
 =C2=A0Thanks,
>

What are the drawbacks of having a vfsmount for each subvolume?

Why (besides having to code it up) are you trying to avoid doing it tha=
t way?
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
