Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scc-mailout-kit-02.scc.kit.edu ([129.13.231.82]:40397 "EHLO
        scc-mailout-kit-02.scc.kit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933694AbeFKQmd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 12:42:33 -0400
From: Simon Kaiser <simon.kaiser@kit.edu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: corrupt leaf; unaligned key offset for csum item
In-Reply-To: <f1f681f2-2bed-7686-604a-846bc5078dbf@gmx.com>
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me> <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com> <f1f681f2-2bed-7686-604a-846bc5078dbf@gmx.com>
Date: Mon, 11 Jun 2018 18:42:28 +0200
Message-ID: <87in6pe0ln.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On 2018年06月10日 09:56, Qu Wenruo wrote:
>
> Since there is no other csum error exposed by btrfs check/scrub, the fix
> for this particular csum item key bit flip can be fetched here:
> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>
> The usage will be (after the normal compile procedure)
> $ ./btrfs-corrupt-block -X <device>
>
> It needs to be executed offline (the <device> must be unmounted).
>
> Thanks,
> Qu
>

Thank you very much, that fixed the issue :)

btrfs scrub now shows 5 checksum errors on a single file

[ 1869.456426] BTRFS warning (device sda5): checksum error at logical 1271386112 on dev /dev/sda5, physical 1271386112, root 257, inode 8016535, offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000000000001-00056e3429e252bb.journal)                                                                                                          
[ 1869.456429] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd 370, flush 0, corrupt 1, gen 0
[ 1869.457975] BTRFS warning (device sda5): checksum error at logical 1271390208 on dev /dev/sda5, physical 1271390208, root 257, inode 8016535, offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000000000001-00056e3429e252bb.journal)                                                                                                          
[ 1869.457978] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd 370, flush 0, corrupt 2, gen 0
[ 1869.459381] BTRFS warning (device sda5): checksum error at logical 1271394304 on dev /dev/sda5, physical 1271394304, root 257, inode 8016535, offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000000000001-00056e3429e252bb.journal)                                                                                                          
[ 1869.459383] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd 370, flush 0, corrupt 3, gen 0
[ 1869.460827] BTRFS warning (device sda5): checksum error at logical 1271398400 on dev /dev/sda5, physical 1271398400, root 257, inode 8016535, offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000000000001-00056e3429e252bb.journal)                                                                                                          
[ 1869.460829] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd 370, flush 0, corrupt 4, gen 0
[ 1869.462118] BTRFS warning (device sda5): checksum error at logical 1271402496 on dev /dev/sda5, physical 1271402496, root 257, inode 8016535, offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000000000001-00056e3429e252bb.journal)                                                                                                          
[ 1869.462120] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd 370, flush 0, corrupt 5, gen 0

I don't really need that file, can I simply delete it and forget about
it or is there something else I should do?

Yours,
Simon
