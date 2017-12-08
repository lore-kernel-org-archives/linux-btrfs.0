Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:39775 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdLHUY2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 15:24:28 -0500
Received: by mail-qk0-f171.google.com with SMTP id u184so382879qkd.6
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Dec 2017 12:24:27 -0800 (PST)
Date: Fri, 8 Dec 2017 15:24:25 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Josef Bacik <josef@toxicpanda.com>, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 0/5] Add the ability to do BPF directed error injection
Message-ID: <20171208202424.cxvsbf3v2huiolqn@destiny>
References: <1512576737-9417-1-git-send-email-josef@toxicpanda.com>
 <439bccca-53e8-408e-972c-7f1b25ba0da6@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <439bccca-53e8-408e-972c-7f1b25ba0da6@iogearbox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 08, 2017 at 04:35:44PM +0100, Daniel Borkmann wrote:
> On 12/06/2017 05:12 PM, Josef Bacik wrote:
> > Jon noticed that I had a typo in my _ASM_KPROBE_ERROR_INJECT macro.  I went to
> > figure out why the compiler didn't catch it and it's because it was not used
> > anywhere.  I had copied it from the trace blacklist code without understanding
> > where it was used as cscope didn't find the original macro I was looking for, so
> > I assumed it was some voodoo and left it in place.  Turns out cscope failed me
> > and I didn't need the macro at all, the trace blacklist thing I was looking at
> > was for marking assembly functions as blacklisted and I have no intention of
> > marking assembly functions as error injectable at the moment.
> > 
> > v7->v8:
> > - removed the _ASM_KPROBE_ERROR_INJECT since it was not needed.
> 
> The series doesn't apply cleanly to the bpf-next tree, so one last respin with
> a rebase would unfortunately still be required, thanks!

I've rebased and let it sit in my git tree to make sure kbuild test bot didn't
blow up, can you pull from

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git bpf-override-return

or do you want me to repost the whole series?  Thanks,

Josef
