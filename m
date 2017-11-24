Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44231 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbdKXJqg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 04:46:36 -0500
Subject: Re: [PATCH v7 3/5] bpf: add a bpf_override_function helper
To: Josef Bacik <josef@toxicpanda.com>, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
References: <1511385814-20863-1-git-send-email-josef@toxicpanda.com>
 <1511385814-20863-4-git-send-email-josef@toxicpanda.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9b416c77-33f8-dacc-82c3-811a265155ed@iogearbox.net>
Date: Fri, 24 Nov 2017 10:46:28 +0100
MIME-Version: 1.0
In-Reply-To: <1511385814-20863-4-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/22/2017 10:23 PM, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Error injection is sloppy and very ad-hoc.  BPF could fill this niche
> perfectly with it's kprobe functionality.  We could make sure errors are
> only triggered in specific call chains that we care about with very
> specific situations.  Accomplish this with the bpf_override_funciton
> helper.  This will modify the probe'd callers return value to the
> specified value and set the PC to an override function that simply
> returns, bypassing the originally probed function.  This gives us a nice
> clean way to implement systematic error injection for all of our code
> paths.
> 
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Series looks good to me as well; BPF bits:

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
