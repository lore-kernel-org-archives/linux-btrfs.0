From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: revert to static snapshot on reboot
Date: Wed, 11 Jan 2012 11:42:38 +0800
Message-ID: <4F0D052E.703@oracle.com>
References: <20120109064304.18411.qmail@otpproductions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: btrfs@spiritvideo.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120109064304.18411.qmail@otpproductions.com>
List-ID: <linux-btrfs.vger.kernel.org>



  Upcoming btrfs autosnap feature might help your problem-solution.
  But the main part in your case which is to replace the root
  with its snapshot is something beyond the scope of autosnap
  project.

  What is being developed is a set of btrfs-prog sub-command to
  create and manage snapshots with a rule-set. Code is under
  development, if you would like to test and provide feedback
  I can send you a copy this week.

  OR if you want to just know the new feature relevant to you
  its as below (not a complete features list though).

  - Create snapshot automatically based on
     - AD-hoc (package-installation/boot ..etc)
       
     cli eg:
     # btrfs autosnap enable <tag> <retain-policy> <subvol>

     and the cli that a init or package script should call is
     # btrfs autosnap now -t <tag> /btrfs
     which will create a snapshot and reviews its retention policy.

   retention policy can be based on count, based on FS % full, OR
   manually maintained snapshots.


  If you have any feedback pls let me know.

thanks, Anand

On Monday 09,January,2012 02:43 PM, btrfs@spiritvideo.com wrote:
> Hi all --
>
> I just installed my first btrfs-based linux tonight, and I must say it
> gives me a very warm feeling!  Congratulations on all your hard work
> and your fine product.
>
> I administer laptops for a small school, and we want to implement what
> Deep Freeze (http://www.faronics.com/enterprise/deep-freeze) does for
> Windows -- no matter what a student does after they log in, when they
> reboot it is all forgotten and the computer has returned to a standard
> state.
>
> I would think this would be a FAQ, but I have searched the web and
> mailing list for the past couple of hours.
>
> Of course it's easy to mount a snapshot, but then if students make
> changes the snapshot changes.
>
> The plan that occurs to me is to make a snapshot of the system in the
> state that I want to always boot.  Then, I would rewrite the init
> script in the initrd to (a) delete any old tmp copy of the snapshot;
> (b) copy the static snapshot to a tmp copy; (c) mount the tmp copy.
>
> That's a little harder than I was hoping to work -- is there an easier
> way to get this functionality?
>
> I have a small ext4 boot partition containing grub, vmlinuz and
> initramfs.  Everything else is in a big btrfs root partition.  I am
> running Fedora 14, with Fedora-patched linux 2.6.35.  I could upgrade
> if necessary.
>
> Thanks,
> Bob
> --
> I blog about my work at the school at SmallSchoolIT.wordpress.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
