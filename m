From: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: Re: [BUG - btrfs] kernel oops in extent_range_uptodate
Date: Fri, 20 Jan 2012 17:48:57 +0100
Message-ID: <4F199AF9.4030909@gmail.com>
References: <4F182BED.3090009@gmail.com> <CAKcLGm9kVOw6D8kPECfhfohH4pAT=09qws7-jRsh1TZJTyh1_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm9kVOw6D8kPECfhfohH4pAT=09qws7-jRsh1TZJTyh1_A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/19/2012 05:24 PM, Mitch Harder wrote:
> On Thu, Jan 19, 2012 at 8:42 AM, Vincent Vanackere
> <vincent.vanackere@gmail.com>  wrote:
>> Hi,
>>
>> With the most current git kernel (90a4c0f51e8e44111a926be6f4c87af3938a79c3)
>> I'm still getting the same reproducible kernel panic when trying to read a
>> particular file stored on a btrfs filesystem (as seen in the log there are
>> indeed disk media errors on this disk).
>> I'd like the "software" part of this to be fixed - btrfs should definitely
>> not oops even in case of media error - before sending the disk to RMA. Is
>> there anything I can do to make progress on this ?
>>
> Is this kernel compiled with "Compile the kernel with debug info" (in
> the "Kernel hacking  --->" configuration section)?
>
> It would be nice to have the specific line of code passing the NULL pointer.

The kernel was compiled with debug information but modern linux 
distribution make it really hard to keep your debug information it seems :-(
I even had to compile btrfs builtin to keep the line numbers... Anyway, 
thanks to kexec / kdump I finally managed to get this, hope it helps :

crash> bt -l
PID: 939    TASK: ffff880218a4adc0  CPU: 0   COMMAND: "btrfs-endio-met"
  #0 [ffff88022316b9e0] machine_kexec at ffffffff810366aa
     /usr/src/linux/arch/x86/kernel/machine_kexec_64.c: 339
  #1 [ffff88022316ba50] crash_kexec at ffffffff810b2df8
     /usr/src/linux/kernel/kexec.c: 1101
  #2 [ffff88022316bb20] oops_end at ffffffff816afdd8
     /usr/src/linux/arch/x86/kernel/dumpstack.c: 228
  #3 [ffff88022316bb50] no_context at ffffffff816a3141
     /usr/src/linux/arch/x86/mm/fault.c: 690
  #4 [ffff88022316bbb0] __bad_area_nosemaphore at ffffffff816a3321
     /usr/src/linux/arch/x86/mm/fault.c: 767
  #5 [ffff88022316bc10] bad_area_nosemaphore at ffffffff816a3353
     /usr/src/linux/arch/x86/mm/fault.c: 775
  #6 [ffff88022316bc20] do_page_fault at ffffffff816b29b6
     /usr/src/linux/arch/x86/mm/fault.c: 1122
  #7 [ffff88022316bd30] page_fault at ffffffff816af235
     /usr/src/linux/arch/x86_64/kernel/entry.S
     [exception RIP: extent_range_uptodate+89]
     RIP: ffffffff812c7239  RSP: ffff88022316bde0  RFLAGS: 00010246
     RAX: 0000000000000000  RBX: 000000df57385000  RCX: 0000000000000000
     RDX: 0000000000000001  RSI: 000000000df57385  RDI: 0000000000000000
     RBP: ffff88022316be00   R8: 0000000000000000   R9: ffff88021f2823c0
     R10: ffff88022034d010  R11: 0000000000001000  R12: ffff880222908410
     R13: 000000df573853ff  R14: ffff88022316be98  R15: ffff88021a3e72a8
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #8 [ffff88022316be08] end_workqueue_fn at ffffffff812a04b9
     /usr/src/linux/fs/btrfs/disk-io.c: 1564
  #9 [ffff88022316be38] worker_loop at ffffffff812d18bf
     /usr/src/linux/arch/x86/include/asm/atomic.h: 107
#10 [ffff88022316bee8] kthread at ffffffff81070193
     /usr/src/linux/kernel/kthread.c: 121
#11 [ffff88022316bf48] kernel_thread_helper at ffffffff816b8124
     /usr/src/linux/arch/x86/kernel/entry_64.S: 1163
