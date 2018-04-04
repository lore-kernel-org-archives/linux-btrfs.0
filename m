Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:43555 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753040AbeDDC3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Apr 2018 22:29:21 -0400
Received: by mail-ot0-f196.google.com with SMTP id m22-v6so21674045otf.10
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Apr 2018 19:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ad1a25fd-0dce-eb5f-c4ca-1aa4fdb5c63b@central-intelligence.agency>
References: <ad1a25fd-0dce-eb5f-c4ca-1aa4fdb5c63b@central-intelligence.agency>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 3 Apr 2018 20:29:20 -0600
Message-ID: <CAJCQCtQK7YCQ1OXidMBxx7ssWkN_nGN1jt7iJXFQreHCE-9XUw@mail.gmail.com>
Subject: Re: System freezes a lot - btrfs trace in dmesg - symptom or cause?
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FWIW, gmail considers the original post a phishing attempt, and put it
into spam. Also the sending mail server marked the header with a
request that subsequent mail servers fail to forward the email, which
effectively makes it incompatible with mail servers which modify the
email body, making dkim message verification fail. So I suggest either
clearing it up with the mail provider or using a different email for
lists.

This message has a from address in central-intelligence.agency but has
failed central-intelligence.agency's required tests for
authentication.  Learn more

Authentication-Results: mx.google.com;
       dkim=neutral (body hash did not verify)
header.i=@central-intelligence.agency header.s=default
header.b=eqsLMYnQ;
       spf=pass (google.com: best guess record for domain of
linux-btrfs-owner@vger.kernel.org designates 209.132.180.67 as
permitted sender) smtp.mailfrom=linux-btrfs-owner@vger.kernel.org;
       dmarc=fail (p=REJECT sp=REJECT dis=QUARANTINE)
header.from=central-intelligence.agency



On Tue, Apr 3, 2018 at 3:35 PM, Richard Schwab
<kernelorg-djthmw7n9w@central-intelligence.agency> wrote:
> Hi there,
>
> I'm currently having some issues with my system freezing a lot, from a
> few seconds up to a few minutes. I haven't figured out yet what might be
> causing this, however, coincidentally some btrfs notices appeared in my
> dmesg after I had a freeze for about 5 minutes. I'm wondering whether
> this is just another symptom of my system having some weird issues or
> whether this might actually be the cause of the freezes I've been
> experiencing.

>From the attached text file

10691.693188] INFO: task btrfs-transacti:447 blocked for more than 120 seconds.
[10691.693196]       Tainted: P           O     4.15.14-1-ARCH #1
[10691.693199] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[10691.693202] btrfs-transacti D    0   447      2 0x80000000
[10691.693207] Call Trace:
[10691.693221]  ? __schedule+0x24b/0x8c0
[10691.693229]  ? enqueue_entity+0x59b/0xc70
[10691.693234]  schedule+0x32/0x90
[10691.693239]  io_schedule+0x12/0x40
[10691.693247]  __lock_page+0xf8/0x130
[10691.693252]  ? add_to_page_cache_lru+0xe0/0xe0
[10691.693309]  read_extent_buffer_pages+0xf0/0x2f0 [btrfs]
[10691.693337]  ? btrfs_alloc_root+0x30/0x30 [btrfs]
[10691.693365]  btree_read_extent_buffer_pages+0x94/0xf0 [btrfs]
[10691.693389]  read_block_for_search.isra.14+0x15a/0x2f0 [btrfs]
[10691.693413]  btrfs_search_slot+0x3cd/0xa00 [btrfs]
[10691.693437]  ? block_group_cache_tree_search+0xba/0xd0 [btrfs]
[10691.693460]  btrfs_insert_empty_items+0x66/0xb0 [btrfs]
[10691.693484]  alloc_reserved_file_extent+0x96/0x320 [btrfs]
[10691.693511]  __btrfs_run_delayed_refs+0x908/0x1180 [btrfs]
[10691.693539]  btrfs_run_delayed_refs+0xe5/0x1b0 [btrfs]
[10691.693566]  btrfs_start_dirty_block_groups+0x2cb/0x470 [btrfs]
[10691.693596]  btrfs_commit_transaction+0x117/0x930 [btrfs]
[10691.693626]  ? start_transaction+0x9e/0x420 [btrfs]
[10691.693654]  transaction_kthread+0x17b/0x1a0 [btrfs]
[10691.693684]  ? btrfs_cleanup_transaction+0x570/0x570 [btrfs]
[10691.693687]  kthread+0x113/0x130
[10691.693691]  ? kthread_create_on_node+0x70/0x70
[10691.693695]  ret_from_fork+0x35/0x40
[10691.693703] INFO: task journal-offline:7151 blocked for more than
120 seconds.


Off hand it just looks like noise, it's only an info message. But of
course the hung task is super annoying and maybe makes it worse than
if it were to just crash. Anyway, best to reproduce and issue sysrq +
w and hopefully a dev will get around to giving an opinion on what's
going on. In the meantime you can try reverting to 4.14.32 or try
4.16.0. I'm not seeing anything off hand in 4.15.15 that relates, so I
suspect it still happens with that version. Another thing to try is
booting without the proprietary driver you're using that taints the
kernel. It may very well be unrelated to this problem, but ...

https://www.kernel.org/doc/Documentation/admin-guide/sysrq.rst

Translated it means do this:

sudo -i
echo 1 > /proc/sys/kernel/sysrq
echo w > /proc/sysrq-trigger
exit
sudo journalctl -o short-monotonic -k > kernelmsg+sysrqw.log

And then post that log file somewhere like dropbox or whatever, it may
be too big to attach to the list but you can try it.


-- 
Chris Murphy
