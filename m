Return-Path: <SRS0=3O7H=PG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0E0C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Dec 2018 23:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A43F2075D
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Dec 2018 23:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=inv.alid.pw header.i=@inv.alid.pw header.b="mqA4Akd1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m5v2nkjC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbeL2X4g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 18:56:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60915 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbeL2X4g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 18:56:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D746A213B9
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2018 18:56:34 -0500 (EST)
Received: from web1 ([10.202.2.211])
  by compute4.internal (MEProxy); Sat, 29 Dec 2018 18:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inv.alid.pw; h=
        message-id:from:to:mime-version:content-transfer-encoding
        :content-type:date:subject; s=mesmtp; bh=ebVnWS5H4rsN7ukvUKDzSIC
        L9VYjcgvkNhSIcvbGEhw=; b=mqA4Akd1mqEBmGZGfu53reMNq4SIGf3ymn3/XrT
        uGXwE+eXPyGCe8WP4rI1hkCsI76t1XPkuq6WHckeEYmGZLfsv12o5Oi29mAv2vxk
        4QBAq4wk8BxJ4Yi6Tp/KCd+P+6CI6QQkS3yBHhj/nm//QmmRBWd7g7N0FY4ii3K+
        Tmg4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ebVnWS
        5H4rsN7ukvUKDzSICL9VYjcgvkNhSIcvbGEhw=; b=m5v2nkjCYgam1lNc1Ncqo0
        yMzIvvpILMs0WdzdeF7Ewu8r4nBYxw8OvwTPUFP/osYkllGYaiCek6GsGSYR7N59
        isRS1vDek/D+fLl4tHyvBpm6gcqQT6TCU6gGUeNS01V/yfpfjgKRnuvIJEB5s4Jv
        eBQqrSCjhb7z93KVurG0AkxVdW3eQPwtZtDcVVYDMzxnQN8sR990ssiOxjTOCM1n
        717W5NhpAkO+UO9zMFHTVmC0qEk6t0+lEDUzrq6M+HOgj3dvj9FFAZV0Nas5Nl1j
        GNSnIlXa83TNJTzJO6AChG2qn2o5a+qd4kvNiqMBSlXI9EOlxOUDl+JpEDmc0FCw
        ==
X-ME-Sender: <xms:sgkoXE-FSEuBA4TLYfSLOyTkeNBowZQUahYaHnm_SbkClhrwFzN0LA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrtdelgddujeculddtuddrgedtkedrtddtmd
    cutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenucfjughrpefkhf
    fvggfgtgfofffusehtjeertdertdejnecuhfhrohhmpeflohhshhcujfholhhlrghnugcu
    oehjohhshhesihhnvhdrrghlihgurdhpfieqnecuffhomhgrihhnpegrlhhiugdrphifne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehjohhshhesihhnvhdrrghlihgurdhpfienucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:sgkoXH0l7eBqST4RPsJHGVgA8RLu7zvMeBQ7EEHSoGJMKX5G34BijA>
    <xmx:sgkoXAbrkFxOZ5gMmeRXG50pT_XHxuseO6NdoDSzhtqUaXNWnCA2pg>
    <xmx:sgkoXPZl9rwW9aWKd14VOA_qLVg1D0OuZeObYCCI2uvhKcxN3N81Jg>
    <xmx:sgkoXD3HLQojSSNtKnzxb-7oSLZkkqyTEBMBrZEeFPqg4dskq-zLnA>
Received: by mailuser.nyi.internal (Postfix, from userid 99)
        id 6CFE39423C; Sat, 29 Dec 2018 18:56:34 -0500 (EST)
Message-Id: <1546127794.2573034.1620895648.01F06240@webmail.messagingengine.com>
From:   Josh Holland <josh@inv.alid.pw>
To:     linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-2f590f9a
Date:   Sat, 29 Dec 2018 23:56:34 +0000
Subject: Checksum errors
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

My btrfs partition will not mount. I spent some time in the IRC, where darkling said it was due to checksum errors, but we couldn't find a solution. The kernel version is 4.19.12 and btrfsprogs are at 4.19.1. Unfortunately I wasn't able to get a network connection on the computer in question, so instead of using a pastebin I shared pictures from my phone, linked below. 

dmesg errors: https://oc.inv.alid.pw/s/ZHdJprfg4ZQmXWG
btrfs check output: https://oc.inv.alid.pw/s/JabKEqpXG3greq3
btrfs inspect dump-super: https://oc.inv.alid.pw/s/RqKSRkg7Z7n8AyF

I'll probably end up restoring this from my backups, but I'd prefer not to have to do that unless it's really necessary. Any help is much appreciated; I'll try getting the network up to paste the errors in plain text tomorrow, along with a full copy of dmesg. 

Thanks,
Josh
