Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52698 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753112AbdLHXZY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 18:25:24 -0500
Subject: Re: [PATCH v8 0/5] Add the ability to do BPF directed error injection
To: Josef Bacik <josef@toxicpanda.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <1512576737-9417-1-git-send-email-josef@toxicpanda.com>
 <439bccca-53e8-408e-972c-7f1b25ba0da6@iogearbox.net>
 <20171208202424.cxvsbf3v2huiolqn@destiny>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86804f71-09e9-a3ee-a585-d4e692913616@iogearbox.net>
Date: Sat, 9 Dec 2017 00:25:16 +0100
MIME-Version: 1.0
In-Reply-To: <20171208202424.cxvsbf3v2huiolqn@destiny>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/2017 09:24 PM, Josef Bacik wrote:
> On Fri, Dec 08, 2017 at 04:35:44PM +0100, Daniel Borkmann wrote:
>> On 12/06/2017 05:12 PM, Josef Bacik wrote:
>>> Jon noticed that I had a typo in my _ASM_KPROBE_ERROR_INJECT macro.  I went to
>>> figure out why the compiler didn't catch it and it's because it was not used
>>> anywhere.  I had copied it from the trace blacklist code without understanding
>>> where it was used as cscope didn't find the original macro I was looking for, so
>>> I assumed it was some voodoo and left it in place.  Turns out cscope failed me
>>> and I didn't need the macro at all, the trace blacklist thing I was looking at
>>> was for marking assembly functions as blacklisted and I have no intention of
>>> marking assembly functions as error injectable at the moment.
>>>
>>> v7->v8:
>>> - removed the _ASM_KPROBE_ERROR_INJECT since it was not needed.
>>
>> The series doesn't apply cleanly to the bpf-next tree, so one last respin with
>> a rebase would unfortunately still be required, thanks!
> 
> I've rebased and let it sit in my git tree to make sure kbuild test bot didn't
> blow up, can you pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git bpf-override-return
> 
> or do you want me to repost the whole series?  Thanks,

Yeah, the patches would need to end up on netdev, so once kbuild bot went
through fine after your rebase, please send the series.

Thanks,
Daniel
