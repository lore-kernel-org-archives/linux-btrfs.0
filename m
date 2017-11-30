Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36611 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdK3UPj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 15:15:39 -0500
Received: by mail-qt0-f195.google.com with SMTP id a16so10390218qtj.3
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 12:15:39 -0800 (PST)
Date: Thu, 30 Nov 2017 15:15:37 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Josef Bacik <josef@toxicpanda.com>, Jonathan Corbet <corbet@lwn.net>,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v7 1/5] add infrastructure for tagging functions as error
 injectable
Message-ID: <20171130201535.7eeawg77yixnqjks@destiny>
References: <1511385814-20863-1-git-send-email-josef@toxicpanda.com>
 <1511385814-20863-2-git-send-email-josef@toxicpanda.com>
 <20171128115841.4958113d@lwn.net>
 <20171128200241.tr5d6a2obvxl6inb@destiny>
 <83414bdd-2e83-bc77-da90-33ee43b89a97@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <83414bdd-2e83-bc77-da90-33ee43b89a97@iogearbox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 05:59:39PM +0100, Daniel Borkmann wrote:
> On 11/28/2017 09:02 PM, Josef Bacik wrote:
> > On Tue, Nov 28, 2017 at 11:58:41AM -0700, Jonathan Corbet wrote:
> >> On Wed, 22 Nov 2017 16:23:30 -0500
> >> Josef Bacik <josef@toxicpanda.com> wrote:
> >>> From: Josef Bacik <jbacik@fb.com>
> >>>
> >>> Using BPF we can override kprob'ed functions and return arbitrary
> >>> values.  Obviously this can be a bit unsafe, so make this feature opt-in
> >>> for functions.  Simply tag a function with KPROBE_ERROR_INJECT_SYMBOL in
> >>> order to give BPF access to that function for error injection purposes.
> >>>
> >>> Signed-off-by: Josef Bacik <jbacik@fb.com>
> >>> Acked-by: Ingo Molnar <mingo@kernel.org>
> >>> ---
> >>>  arch/x86/include/asm/asm.h        |   6 ++
> >>>  include/asm-generic/vmlinux.lds.h |  10 +++
> >>>  include/linux/bpf.h               |  11 +++
> >>>  include/linux/kprobes.h           |   1 +
> >>>  include/linux/module.h            |   5 ++
> >>>  kernel/kprobes.c                  | 163 ++++++++++++++++++++++++++++++++++++++
> >>>  kernel/module.c                   |   6 +-
> >>>  7 files changed, 201 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> >>> index b0dc91f4bedc..340f4cc43255 100644
> >>> --- a/arch/x86/include/asm/asm.h
> >>> +++ b/arch/x86/include/asm/asm.h
> >>> @@ -85,6 +85,12 @@
> >>>  	_ASM_PTR (entry);					\
> >>>  	.popsection
> >>>  
> >>> +# define _ASM_KPROBE_ERROR_INJECT(entry)			\
> >>> +	.pushsection "_kprobe_error_inject_list","aw" ;		\
> >>> +	_ASM_ALIGN ;						\
> >>> +	_ASM_PTR (entry);					\
> >>> +	.popseciton
> >>
> >> So this stuff is not my area of greatest expertise, but I do have to wonder
> >> how ".popseciton" can work ... ?
> > 
> > Well fuck, do you want me to send a increment Daniel/Alexei or resend this patch
> > fixed?  Thanks,
> 
> Sorry for late reply, please rebase + respin the whole series with
> this fixed. There were also few typos in the cover letter / commit
> messages that would be good to get fixed along the way.
> 
> Also, could you debug why this wasn't caught at compile/runtime during
> testing?
> 

Sat down to figure out what was wrong here, and realized I'm just an idiot.  I
was copying the no kprobe stuff, and my grepping did not uncover what
_ASM_NOKPROBE() was used for, so I assumed it was some auto generated magic and
just copied what it did to cover my bases.  Sat down to figure it out and it is
actually called in some assembly files (which is why cscope didn't find it).  So
we don't need _ASM_KPROBE_ERROR_INJECT at all.  I'll drop it and respin and send
it along.  Thanks,

Josef
