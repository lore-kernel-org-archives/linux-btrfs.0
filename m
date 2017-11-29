Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:47293 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdK2RAB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 12:00:01 -0500
Subject: Re: [PATCH v7 1/5] add infrastructure for tagging functions as error
 injectable
To: Josef Bacik <josef@toxicpanda.com>, Jonathan Corbet <corbet@lwn.net>
Cc: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
References: <1511385814-20863-1-git-send-email-josef@toxicpanda.com>
 <1511385814-20863-2-git-send-email-josef@toxicpanda.com>
 <20171128115841.4958113d@lwn.net> <20171128200241.tr5d6a2obvxl6inb@destiny>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <83414bdd-2e83-bc77-da90-33ee43b89a97@iogearbox.net>
Date: Wed, 29 Nov 2017 17:59:39 +0100
MIME-Version: 1.0
In-Reply-To: <20171128200241.tr5d6a2obvxl6inb@destiny>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/28/2017 09:02 PM, Josef Bacik wrote:
> On Tue, Nov 28, 2017 at 11:58:41AM -0700, Jonathan Corbet wrote:
>> On Wed, 22 Nov 2017 16:23:30 -0500
>> Josef Bacik <josef@toxicpanda.com> wrote:
>>> From: Josef Bacik <jbacik@fb.com>
>>>
>>> Using BPF we can override kprob'ed functions and return arbitrary
>>> values.  Obviously this can be a bit unsafe, so make this feature opt-in
>>> for functions.  Simply tag a function with KPROBE_ERROR_INJECT_SYMBOL in
>>> order to give BPF access to that function for error injection purposes.
>>>
>>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>>> Acked-by: Ingo Molnar <mingo@kernel.org>
>>> ---
>>>  arch/x86/include/asm/asm.h        |   6 ++
>>>  include/asm-generic/vmlinux.lds.h |  10 +++
>>>  include/linux/bpf.h               |  11 +++
>>>  include/linux/kprobes.h           |   1 +
>>>  include/linux/module.h            |   5 ++
>>>  kernel/kprobes.c                  | 163 ++++++++++++++++++++++++++++++++++++++
>>>  kernel/module.c                   |   6 +-
>>>  7 files changed, 201 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
>>> index b0dc91f4bedc..340f4cc43255 100644
>>> --- a/arch/x86/include/asm/asm.h
>>> +++ b/arch/x86/include/asm/asm.h
>>> @@ -85,6 +85,12 @@
>>>  	_ASM_PTR (entry);					\
>>>  	.popsection
>>>  
>>> +# define _ASM_KPROBE_ERROR_INJECT(entry)			\
>>> +	.pushsection "_kprobe_error_inject_list","aw" ;		\
>>> +	_ASM_ALIGN ;						\
>>> +	_ASM_PTR (entry);					\
>>> +	.popseciton
>>
>> So this stuff is not my area of greatest expertise, but I do have to wonder
>> how ".popseciton" can work ... ?
> 
> Well fuck, do you want me to send a increment Daniel/Alexei or resend this patch
> fixed?  Thanks,

Sorry for late reply, please rebase + respin the whole series with
this fixed. There were also few typos in the cover letter / commit
messages that would be good to get fixed along the way.

Also, could you debug why this wasn't caught at compile/runtime during
testing?

Thanks a lot,
Daniel
