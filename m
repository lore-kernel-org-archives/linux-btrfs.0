Return-Path: <SRS0=p5gK=R3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A727C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 10:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D05F321B24
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 10:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfCXKtd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Mar 2019 06:49:33 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39223 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfCXKtc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Mar 2019 06:49:32 -0400
Received: by mail-oi1-f195.google.com with SMTP id n187so2029283oih.6
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2019 03:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=MEE94AfHQRz+B66vEmoJQ0TghbraJEKc6J3A7z/FkJg=;
        b=QyiziYA3p8hARccDxB59Lese2KLNsdKz2yNTEQ8ln2FKnwJUyo23EbsPkwM4C1dmnF
         wAhJQPWwn4lllaPQzyZfbNmhvRyXWBcXWavDyi7gAwci5oKWc1TtwcLz89mJV7J3/GHc
         MjqE53qNQ1bEBk124OX2ZmXJ8Y3EprSQ0JcP/s2kQCYMu5IOYfXnqmN9K1VZ35ONVazq
         TYBJqeKntVkJbC1yqERUZ3YOjCFUX4CoceKSTHLgNXSbn1reu2Yz2Js/44bAiL+UJ1LC
         SvAwO2s170ZRMOyINHAN7xmnFNRoQQ/kPO6y1idMP3tONruWONFfAIL6k464lGsUp6HN
         yaFQ==
X-Gm-Message-State: APjAAAWHbOZtZi90YtW9BTKFB30dHleB/ngqYc4ELPXrIj9qkeWT7mgk
        K192FBFu6f71jRBnt4SRrCNr6CG5eVB5BCo3FDDkwaar
X-Google-Smtp-Source: APXvYqz0IQ0CZRkQdflbZaA8/tX6jJYKykxCynp3Z/wRDZ9QfTwTDhshxpSS2zba2b6+VUeDlyqCSqYdvawqlJk/EKc=
X-Received: by 2002:aca:3fc4:: with SMTP id m187mr7464376oia.37.1553424571348;
 Sun, 24 Mar 2019 03:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
 <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com> <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
 <CAH+WbHyQTxbz5inf31AgmAG1BvVWyTAExn3Nf_qvvEQWzZ0tHA@mail.gmail.com> <4dc0ed1a-3f90-56a2-b526-c26cb78d7932@gmx.com>
In-Reply-To: <4dc0ed1a-3f90-56a2-b526-c26cb78d7932@gmx.com>
From:   Thorsten Hirsch <t.hirsch@web.de>
Date:   Sun, 24 Mar 2019 11:49:19 +0100
Message-ID: <CAH+WbHw1cm96YNjVhmdFP4qZ_HR3mzfmojna=d-MeydCtunG1g@mail.gmail.com>
Subject: Re: Fwd: Fw: kernel oops when mounting btrfs
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

thank you once again for your advice. I could indeed recover all my
data, even the snapshots docker had created. Everything's working as
if nothing had ever happened. Here's what I've did in the end:

btrfs recover <src> <dest> worked flawless, but only recovered some data.
mount -o ro,notreelog,nologreplay was the only way to mount the broken
partition and it showed me a lot more data than btrfs recover could
recover. However when trying to access these additional files I had
input/output errors.

btrfs recover -sxmS <src> <dest> was the magic command that recovered
all my data (which I could "cp -a" back to my device after creating a
new btrfs file system). After reading the help of btrfs-recover it's
obvious that the arguments are required, but in the btrfs wiki it says
"If you're really lucky, this might be enough"[1] describing the
command w/o arguments. I think this is misleading. The arguments are
always necessary if you want to recover all your data. Well, at least
I think the wiki page makes mores sense if the arguments were
included.

If there's anything I can provide to help you improve btrfs or its
recovery tools please don't hesitate to ask. Although I don't have an
image of the broken partition, at least I still have the core dump of
"btrfs check --clear-space-cache v1".

[1] https://btrfs.wiki.kernel.org/index.php/Restore

Thorsten Hirsch

P.S.: btrfs check --repair was of no use. It crashed almost
immediately. I tried it only after recovering all my data, to see if
it would've helped as well.

Am Sa., 23. März 2019 um 14:57 Uhr schrieb Qu Wenruo <quwenruo.btrfs@gmx.com>:
>
>
>
> On 2019/3/23 下午6:48, Thorsten Hirsch wrote:
> > Hi Qu,
> >
> > sorry for this direct reply. I've been trying to answer to the mailing
> > list since yesterday, but my mails seem to get dropped. So please see
> > my answer to your mail enclosed.
> >
> > Thorsten
> >
> >
> > ---------- Forwarded message ---------
> > From: Thorsten Hirsch <t.hirsch@web.de>
> > Date: Sa., 23. März 2019 um 09:29 Uhr
> > Subject: Re: Fw: kernel oops when mounting btrfs
> > To: <linux-btrfs@vger.kernel.org>
> >
> >
> > Hi Qu,
> >
> > thank you, but unfortunately that didn't work out so well. The tree
> > dump was no problem [1], but clearing the space cache resulted in a
> > core dump. Now btrfs check --readonly reports some errors. I attached
> > the output of these commands.
> >
> > Thorsten
> >
> > [1] https://gist.github.com/thorstenhirsch/65d4308ce54729c902cb09c0d4ad2baf
>
> This explains why a lot of things doesn't go correct.
>
> The inode item of your free space cache tree is wrong.
> According to my experimental with latest kernel, it looks like some
> older kernel is the culprit.
>
> Your free space cache inode lacks the correct mode.
> Normally the mode should be 0100600. But your fs only has 0, and kernel
> panics for that reason.
>
> >
> > # btrfs check --clear-space-cache v1 /dev/nvme0n1p3
> > Opening filesystem to check...
> > Checking filesystem on /dev/nvme0n1p3
> > UUID: 4284a794-ad75-450d-b023-ebc5e75f31f5
> > Failed to find [544448348160, 168, 16384]
>
> Then this means something bad happened in extent tree.
>
> > btrfs unable to find ref byte nr 544448364544 parent 0 root 2  owner 0 offset 0
> > transaction.c:195: btrfs_commit_transaction: BUG_ON `ret` triggered, value -5
> > btrfs(+0x3be68)[0x556936269e68]
> > btrfs(btrfs_commit_transaction+0x12a)[0x55693626a2ec]
> > btrfs(btrfs_clear_free_space_cache+0x32a)[0x55693625fecf]
> > btrfs(+0x4be5b)[0x556936279e5b]
> > btrfs(cmd_check+0x5c2)[0x556936284d86]
> > btrfs(main+0x1f6)[0x556936241ef6]
> > /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xeb)[0x7fb9a7911b6b]
> > btrfs(_start+0x2a)[0x556936241f3a]
> > Aborted (core dumped)
> >
> >
> > # btrfs check --readonly /dev/nvme0n1p3
> > Opening filesystem to check...
> > parent transid verify failed on 419860414464 wanted 30188 found 30105
> > parent transid verify failed on 419860414464 wanted 30188 found 30105
>
> So extent tree get corrupted in that repair attempt, which looks pretty
> strange, as aborted transaction shouldn't cause any impact on the
> existing fs.
>
> I'm afraid you can only try btrfs check --repair.
>
> If no good result, then I'm afraid you have to go to salvage the data,
> which I believe over 99% of your data should be safe.
>
> To salvage the data, either use btrfs-restore, or you my experimental
> 'skip_bg' kernel patches:
> https://github.com/adam900710/linux/tree/rescue_options
>
> The 'skip_bg' kernel patches introduce a new mount option,
> 'ro,rescue=skip_bg', which can skip the whole (corrupted) extent tree,
> and since you have all trees consistent but extent tree, you have all
> the readonly btrfs features, like subvolume list, csum check.
>
> Thanks,
> Qu
>
