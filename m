Return-Path: <SRS0=1fJ+=ZE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D4FC43331
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Nov 2019 20:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0374F21872
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Nov 2019 20:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="G6uZLhNx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKLUEP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 15:04:15 -0500
Received: from smtp-32.italiaonline.it ([213.209.10.32]:58468 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfKLUEO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Nov 2019 15:04:14 -0500
Received: from venice.bhome ([94.38.75.109])
        by smtp-32.iol.local with ESMTPA
        id UcOaiQNn4hCYOUcOai9Gax; Tue, 12 Nov 2019 21:04:13 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1573589053; bh=F8taB4SYFGOTSOGmFTCc9H2IUIlJllg3AW9tNuyc6K8=;
        h=Reply-To:Subject:To:References:From:Date:In-Reply-To;
        b=G6uZLhNx2XfIx3TBg0QnhH1qffRhffs7ebPTUwB4kWD76eNaGOyMjeKiS9qhI3ezi
         s2Aq6sCnigLBHTD0mjnUcPMS4BEYKo3AhpcCiFj0hSY+n3B9nF5Jra1/wKdzdZk90+
         lHaaAhBx/iEi8XiEnWUBM0TFcpVrAgBGka0Qh2jkYLUC8GLfbVcTyKUs4YKrREQrPY
         OW/YVWLmJD+GCNvQYLUS/i5jSELsvzrangVO/7RSU5GqSmsXpajXtBwRiK24P6IOvN
         ddZZZ+vavL6eaB/7P7OtbbDLOEuAGNrdRZ9TY3FHooGluwW1jvyiJj9WV17b0H0pH5
         EXWDBH2W7X1Dw==
X-CNFS-Analysis: v=2.3 cv=D9k51cZj c=1 sm=1 tr=0
 a=KzXHLLuG32F0DtnFfJanyA==:117 a=KzXHLLuG32F0DtnFfJanyA==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=Nz2EPnZeFgbOLs48wxMA:9
 a=QEXdDO2ut3YA:10
Reply-To: kreijack@inwind.it
Subject: Re: Does GRUB btrfs support log tree?
To:     Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtS1v7waFA=ERafSCSCHmPJVytdFZkJLqNTC3U3Gw3Y7tA@mail.gmail.com>
 <d1874d17-700a-d78d-34be-eec0544c9de2@gmail.com>
 <CAJCQCtTpLTJdRjD7aNJEYXuMO+E65=GiYpKP3Wy5sgOWYs3Hsw@mail.gmail.com>
 <20191104193454.GD3001@twin.jikos.cz>
 <CAJCQCtSiDQA4919YDTyQkW7jPkxMds1K32ym=HgO6KHQLzHw+w@mail.gmail.com>
From:   Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <d2301902-bd5b-7c5a-0354-a5df21ca8eb3@libero.it>
Date:   Tue, 12 Nov 2019 21:04:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSiDQA4919YDTyQkW7jPkxMds1K32ym=HgO6KHQLzHw+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFcEL5Me4XfuX/p4OMBHeUtyeG2GgQ+79A5zZxPULQUONlugseSs/X/ZZaKEou+CULbatEu0FDet6A/pf/vEtknbfCaum3kVf1Udk+X2rnrvLRKsPIcE
 S8ghgDlG6USBRF7BktbcsZVuNgv1r3ruc3VezrhNyIHhtlTLoaLv9X51ooYNIrYpEm072ZscGW/rw9/mUReM6/EoqGvhkomx9RMI8gj551FgU5nipfDJXWGr
 Rbess03d2ORheVpImn49cyLj5qQrnFWpy+JTQJpNEmY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/11/2019 20.37, Chris Murphy wrote:
> Anyway, the lack of a generic (file system independent) way to handle
> this use case is actually a bit concerning.

I think that a more simpler approach would be developing a GRUB fs, where is the kernel to be adapted to the needing of GRUB...
So we can lowering the requirement...

The GRUB-fs should have the following main requirements:
- allow the atomicity guarantee
- allow molti-disk setup
- allow grub to update some file (grubenv come me as first)
- it should require a simple implementation (easy to porting to multiple system, which basically means linux, *bsd and solaris ?)
- the speed should be not important


Anyway GRUB on BTRFS suffers of a big limitation: GRUB can't update the grubenv file; and until GRUB will learn how update a COW filesystem, this limit will be impossible to avoid (*)

G.Baroncelli


(*) Even tough implementing the update of a NOCSUM file should be not so difficult...


