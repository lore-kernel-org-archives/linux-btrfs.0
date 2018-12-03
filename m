Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358AFC04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCCC220661
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="RvgE3ZcW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="v3HbcHmb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCCC220661
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=georgianit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbeLCQ3r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 11:29:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51311 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbeLCQ3r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 11:29:47 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A7E822616;
        Mon,  3 Dec 2018 11:29:44 -0500 (EST)
Received: from web4 ([10.202.2.214])
  by compute2.internal (MEProxy); Mon, 03 Dec 2018 11:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=message-id:from:to:mime-version:content-transfer-encoding
        :content-type:date:subject:references:in-reply-to; s=fm1; bh=6JA
        FoSR4zE5fO0Ow2Ktu4ez+m/bfaZddt5mfI4ehy9E=; b=RvgE3ZcWEkER5BSulFY
        JktC7T7rlXK3IyARs4yp5lXwA2Pdy+cIO/eljRbKRWR7aW0a4VO0NhcyicTLD9gU
        yYyorq43QHxOncp5pcIYCi8RFsRH/Vr/h1xg1OrGNxFqct0sJP5DSkfwxukMxQ8i
        DqtMK43FEbJmuXqqTk/kBF6ZW33MdjbZrezLCBqAs1tzXYrpM4tcMcS+CCwZuFZY
        Ls1mrolzjfRrDSh8ZV2kv1tTGWYmJDmRaT6oQ0oNd7aW+Goi7QniZMYYdIuJzR/O
        yU03Es+XbOaDe8I6ys7IxrHTzRwJHle1JASfoq/TYkmljALjZy2WV97yUqZU+xdy
        7YQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=6JAFoSR4zE5fO0Ow2Ktu4ez+m/bfaZddt5mfI4ehy
        9E=; b=v3HbcHmb6zYS8rE64vY9Y3yD5pXFpzKZ33GeafGZtBL5NM3vdqRx/p560
        SInqDp7V/K1eiC32Jlj0pCmU4a1kJaGVCKnFo6qKvje7qfSwg/o8GXq2Ji3s059h
        Tr1hu5gYW5SSLBYqCe7Zxn1cQ25WJDs+UmmZs6BCR8RQE8E8sv/kD2jgjkZL4ece
        72KbYK/vpGIM3B6lZKnzYHW+2CWWWAQTGPjLVN4t+EZLpofHowY6fSfit6UeI6Rm
        edpYojuG7kFlGDYC0r62EfAFvX8tL/JSSpVR35SCidseFDIV19yaO2Oh6ZIKNDU9
        VZq5BdkF3773RakjbUDFPSnFTfH2A==
X-ME-Sender: <xms:91kFXJL4MysOmVeGDuSeyHK9uy9e8PGvo2r7K_vSLDDjeqpDUffiPA>
X-ME-Proxy: <xmx:91kFXHqRC-2nyLOV5R-WeqokRB-9QX_0mDbCtdFo127ETxW9QhqYTA>
    <xmx:91kFXLDYfgyg8PZCMsp_CBsLt648FFJtoxu6qUNLkCLGmkl_or64jw>
    <xmx:91kFXMug73oNiR4JAoSftEMVIdncH--l_wIJlThL6-3SUsksFSMHHw>
    <xmx:91kFXKZW2iNvh4JP5qR2Bc2UVpSn9d9o6UxkNaQWFK0dAyZOed3_hA>
    <xmx:91kFXIEOhSE0iyTzpGpVhCO430WUP4XPLRtVcNDntZfrDsub7pwgsg>
    <xmx:-FkFXD7A3qxcLI_9dcVbAH3qUSqDcRqKgWK0tNs1FWP5U9PtaiCdyw>
Received: by mailuser.nyi.internal (Postfix, from userid 99)
        id D09FEBA7C4; Mon,  3 Dec 2018 11:29:43 -0500 (EST)
Message-Id: <1543854583.1456380.1597243824.48B56C76@webmail.messagingengine.com>
From:   remi@georgianit.com
To:     Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-3449945b
Date:   Mon, 03 Dec 2018 11:29:43 -0500
Subject: Re: Filesystem Corruption
References: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>
In-Reply-To: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 3, 2018, at 4:31 AM, Stefan Malte Schumacher wrote:

> I have noticed an unusual amount of crc-errors in downloaded rars,
> beginning about a week ago. But lets start with the preliminaries. I
> am using Debian Stretch.
> Kernel: Linux mars 4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u4
> (2018-08-21) x86_64 GNU/Linux
> 
> [5390748.884929] Buffer I/O error on dev dm-0, logical block
> 976701312, async page read


Excuse me for butting when there are *many* more qualified people on this list.

But assuming the rar crc errors are related to your unexplained buffer I/O errors, (and not some weird coincidence of simply bad downloads.), I would start, immediately, by testing the Memory.  Ram corruption can wreak havok with btrfs, (any filesystem but I think BTRFS has special challenges in this regard.)  and this looks like memory error to me.

