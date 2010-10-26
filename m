From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Mark btrfsctl deprecated
Date: Tue, 26 Oct 2010 19:32:14 +0200
Message-ID: <201010261932.15023.kreijack@libero.it>
References: <22986774.2784821287748969875.JavaMail.defaultUser@defaultHost> <AANLkTimiuTM02Dnue_3NdC+uLbCMP9hEjfrp_4efFbGe@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimiuTM02Dnue_3NdC+uLbCMP9hEjfrp_4efFbGe@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 25 October, 2010, David Nicol wrote:
> I am certainly not in a position to answer for Chris Mason, but I am
> happy to share my response to the question, coming from a perspective
> of being somewhat obsessive about not breaking back-compat.

I agree with this sentence; in fact I suggested to mark the program 
"deprecated" with a warning and to remove it after some months.

> 
> Let's not. As I am certainly within the "lot of people" in question,
> having just done exactly that, I found the two programs -- with very
> different styles -- to not be much of a block, and providing two
> examples instead of one of code that invokes an ioctl seems fine.

If you need an example program put it into a directory called "example"... for 
example :)

> 
> Ideally, everyone who needs to use an ioctl will simply write and
> compile a C program that does what they need -- ha ha.
> 
> I see no reason to break legacy code (such as it is) that uses
> btrfsctl instead of btrfs for a user-space tool to invoke ioctls.
> Calling the tool "btrfs" is actually a little confusing.

Ideally "btrfs" had the goal to replace "btrfsctl" (and some other programs). 
This for a lot of reason: btrfctl is buggy, un-maintainable, doesn't handle 
very well a lot of errors..
A lot of posts in this mailing lists reports errors due to a misunderstanding 
of the syntax and behavior of btrfs filesystem and btrfsctl. I hoped writing 
"btrfs" to improve this situation.

Every patch needs a checking and is a potential source of conflicts. Why 
double the effort maintaining two equivalent programs ?

The package btrfs-tools needs a lot of care:
- the INSTALL file still reports that is not possible to remove a subvolume
- a lot of program are not documented (what is the meaning of btrfs-zero-log 
?)
- "btrfs dev scan" and "btrfs -a" try to read CDROM and Floppy looking for a 
btrfs filesystem: only waste of time
- [...]

I think that is better to improve the btrfs-progs and not to update btrfsctl.

Only my 2C

regards
G.Baroncelli



> 
> 
> 
> On Fri, Oct 22, 2010 at 7:02 AM, Goffredo Baroncelli
> <kreijack@libero.it> <kreijack@libero.it> wrote:
> > Hi Chris,
> >
> > what do you think about marking deprecate the "btrfsctl" program ?
> >
> > A lot of people make patch involving both btrfs command and btrfsctl 
command,
> > spending a lot of effort.
> >
> > Initially we can put a warning in the btrfctl command which suggest to use 
the
> > btrfs command. and after XX month (six ?) we could remouve the command at 
all.
> > The same for the other utilities like btrfs-show, btrfs-vol....
> >
> > Of course this is applicable if there is no evidence of regression of 
btrfs vs
> > btrfsctl.
> >
> > Regards
> > G.Baroncelli
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
