From: Erik Jensen <eriksjunk@rkjnsn.net>
Subject: Re: kernel BUG when removing missing drive (Take 2)
Date: Fri, 29 Oct 2010 11:55:49 -0700
Message-ID: <AANLkTi=D8uB-yuH3BUY0uPwEzwVxBPrghN7P-LRJUXq=@mail.gmail.com>
References: <AANLkTimECim-kSVfuZkAS2pfNJi1rtA-voC98YR3iYoT@mail.gmail.com> <20101028205705.GE27796@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Erik Jensen <eriksjunk@rkjnsn.net>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101028205705.GE27796@think>
List-ID: <linux-btrfs.vger.kernel.org>

So, I ended up just applying the relevant commit to my existing source
tree, which did allow me to successfully remove the missing drive, so
I seem to be back up and running.

Thank you very much!

-- Erik

On Thu, Oct 28, 2010 at 1:57 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
>
> On Tue, Oct 19, 2010 at 07:17:16PM -0700, Erik Jensen wrote:
> > One of my drives on my six drive btrfs setup recently died. =A0I
> > initially wasn't too worried about it, since both my data and metad=
ata
> > are raid1. =A0However, I have so far not been able to remove the mi=
ssing
> > drive after several attempts.
> >
> > After discussing my problem on IRC, Chris Mason asked me to list
> > everything I've tried on the mailing list, so here goes:
>
> Ok, so the current code in the scratch branch is probably going to ge=
t
> rebased. =A0I've got some commits in there to add features to the bdi
> code, but those features are still being discussed.
>
> But, if you:
>
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-un=
stable.git scratch
>
> You'll get the scratch branch of the btrfs-unstable repo. =A0It fixes=
 the
> oops on an unwritable missing drive, which I did reproduce locally.
>
> Please let me know how this works
>
> -chris
>
> >
> > 1. I was attempting to cut commercials out of a TV recording when
> > things seemed to stall. =A0A look a dmesg told me that one of my dr=
ives
> > was having many read failures.
> > 2. I shut down my computer and removed the failed drive.
> > 3. I booted back up and mounted the array in degraded mode. =A0A qu=
ick
> > ls showed all my files.
> > 4. I checked my filesystem usage and concluded that I should have
> > enough free space to build back up to full redundancy on the remain=
ing
> > drives, so I would be protected until my replacement arrived.
> > 5. I executed "btrfs-vol -r missing", which churned the hard drives
> > for a little bit and then stalled. =A0dmesg showed this kernel BUG:
> > http://pastebin.com/KgjUUBq0
> > 6. The system wouldn't reboot normally at this point, so I had to u=
se SysRq
> > 7. I temporarily booted a 2.6.35 kernel (I'm currently running 2.6.=
34)
> > and tried to remove the missing drive again, with the same result.
> > 8. [back on 2.6.34] My replacement drive arrived, so I installed it
> > and added it to the btrfs pool.
> > 9. I tried "btrfs-vol -r missing" again, and received the same kern=
el
> > BUG once again.
> > 10. After using SysRq to reboot, I tried doing a "btrfs-vol -b", wh=
ich
> > moved some data around and halted with the same BUG.
> > 11. I checked the kernel source to find why the bug was being throw=
n.
> > The offending line was "BUG_ON(rw =3D=3D WRITE && !dev->writeable);=
" in
> > btrfs_map_bio in volumes.c
> > 12. I used "badblocks -nsv" to make sure of all my hard drives were
> > writeable, which they were.
> >
> > A paste of all of the logged kernel messages from 8 and 9 is at
> > http://pastebin.org/322902
> >
> > I would like to get this figured out as quickly as possible, since =
my
> > data is currently spread across 6 drives with (effectively) no
> > redundancy.
> >
> > I do have C programming experience, so if there is a way that I can
> > help track down the problem, please let me know.
> >
> > Thanks,
> > Erik
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
