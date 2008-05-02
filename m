From: "Jeff Schroeder" <jeffschroed@gmail.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 07:15:32 -0700
Message-ID: <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
References: <200804291601.32945.chris.mason@oracle.com>
	<481A23AB.1020302@suse.com>
	<alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr>
	<200805020852.51125.chris.mason@oracle.com>
Reply-To: jeffschroeder@computer.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: John Johansen <jjohansen@suse.de>, Jeff Mahoney <jeffm@suse.com>,
	linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>,
	kernel-team@lists.ubuntu.com, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <kernel-team-bounces@lists.ubuntu.com>
In-Reply-To: <200805020852.51125.chris.mason@oracle.com>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/kernel-team>
List-Post: <mailto:kernel-team@lists.ubuntu.com>
List-Help: <mailto:kernel-team-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=subscribe>
Errors-To: kernel-team-bounces@lists.ubuntu.com
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 2, 2008 at 5:52 AM, Chris Mason <chris.mason@oracle.com> wrote:
> On Friday 02 May 2008, Jan Engelhardt wrote:
>  > On Thursday 2008-05-01 22:10, Jeff Mahoney wrote:
>  > >>>> Couldn't you #ifdef based on CONFIG_SECURITY_APPARMOR ? This ought to
>  > >>>> work for Hardy. However the next development kernel (Intrepid) does
>  > >>>> not have the APPARMOR patches, so just knowing that its an UBUNTU
>  > >>>> kernel is not specific enough.
>  > >>>
>  > >>> I've been assuming the apparmor patches change remove_suid even when
>  > >>> they are not enabled in the config.
>  > >>
>  > >> Lets get Kees involved. He developed the patch set for Hardy. I would
>  > >> hope that if CONFIG_SECURITY_APPARMOR=n then the source would default to
>  > >> its normal state.
>  > >
>  > >remove_suid() isn't the only change AppArmor makes to the VFS interface.
>  > >It's pretty invasive and requires that dentries are passed with a
>  > >companion vfsmount in most cases. Putting #ifdefs around all that code
>  > >would make the problem worse, not better.
>  >
>  > An alternative approach, and IMHO better suited, is to:
>  >
>  >       make -C ${kdir} all I_HAZ_AN_APPARMOR=1
>
>  This is better than the current situation (oops without any clues), but I'd
>  prefer that people not have to know what apparmor is or if they have it.
>  (This isn't a knock on apparmor, I'd just rather take care of it
>  automagically).

Chris,

Make is not my forte, but here is a working test to see if apparmor
exists in Ubuntu 8.04.
Maybe have make apply a patch to the btrfs source if this test
succeeds? Does this work in SUSE?

http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test_for_btrfs.patch

The symlink from /lib/modules/`uname -r`/build ->
/path/to/kernel/headers/ doesn't exist on CentOS 5.
Even though it is a hack, is this or something like it usable? Or is
this the completely wrong direction?

-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com
