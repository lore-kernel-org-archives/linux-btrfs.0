Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:58361 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbdLHPfv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 10:35:51 -0500
Subject: Re: [PATCH v8 0/5] Add the ability to do BPF directed error injection
To: Josef Bacik <josef@toxicpanda.com>, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <1512576737-9417-1-git-send-email-josef@toxicpanda.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <439bccca-53e8-408e-972c-7f1b25ba0da6@iogearbox.net>
Date: Fri, 8 Dec 2017 16:35:44 +0100
MIME-Version: 1.0
In-Reply-To: <1512576737-9417-1-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/06/2017 05:12 PM, Josef Bacik wrote:
> Jon noticed that I had a typo in my _ASM_KPROBE_ERROR_INJECT macro.  I went to
> figure out why the compiler didn't catch it and it's because it was not used
> anywhere.  I had copied it from the trace blacklist code without understanding
> where it was used as cscope didn't find the original macro I was looking for, so
> I assumed it was some voodoo and left it in place.  Turns out cscope failed me
> and I didn't need the macro at all, the trace blacklist thing I was looking at
> was for marking assembly functions as blacklisted and I have no intention of
> marking assembly functions as error injectable at the moment.
> 
> v7->v8:
> - removed the _ASM_KPROBE_ERROR_INJECT since it was not needed.

The series doesn't apply cleanly to the bpf-next tree, so one last respin with
a rebase would unfortunately still be required, thanks!
