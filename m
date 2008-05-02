From: Tim Gardner <timg@tpi.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 02 May 2008 10:06:38 -0600
Message-ID: <481B3C0E.502@tpi.com>
References: <200804291601.32945.chris.mason@oracle.com>
	<200805020852.51125.chris.mason@oracle.com>
	<c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
	<200805021034.08358.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
	Jeff Mahoney <jeffm@suse.com>, jeffschroeder@computer.org,
	Jan Engelhardt <jengelh@medozas.de>,
	kernel-team@lists.ubuntu.com, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <kernel-team-bounces@lists.ubuntu.com>
In-Reply-To: <200805021034.08358.chris.mason@oracle.com>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/kernel-team>
List-Post: <mailto:kernel-team@lists.ubuntu.com>
List-Help: <mailto:kernel-team-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=subscribe>
Errors-To: kernel-team-bounces@lists.ubuntu.com
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Friday 02 May 2008, Jeff Schroeder wrote:
> 
> [ Btrfs oops with apparmor patched in ]
> 
>> Make is not my forte, but here is a working test to see if apparmor
>> exists in Ubuntu 8.04.
>> Maybe have make apply a patch to the btrfs source if this test
>> succeeds? Does this work in SUSE?
>>
>> http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test
>> _for_btrfs.patch
>>
> 
> Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
> the kernel has the patch.  Lets go back to Jeff's suse patch:
> 
> /*
>  * Even if AppArmor isn't enabled, it still has different prototypes.
>  * Add more distro/version pairs here to declare which has AppArmor applied.
>  */
> #if defined(CONFIG_SUSE_KERNEL)
> # if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
> # define REMOVE_SUID_PATH 1
> # endif
> #endif
> 
> Could someone from Ubuntu please suggest a replacement for CONFIG_SUSE_KERNEL 
> and KERNEL_VERSION(2,6,22) that would correspond with ubuntu kernels shipped 
> with apparmor?  We don't need some define from the apparmor patch, just a 
> global flag that says it comes from ubuntu is enough.
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

To the best of my knowledge, the AppArmor patches are arch and flavour
independent. If CONFIG_SECURITY_APPARMOR exists, then the AA code is
compiled. This is certainly the case for Hardy. Neither Kees or myself
are aware of any reason why it won't also hold true for Intrepid.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
