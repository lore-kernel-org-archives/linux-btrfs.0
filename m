Return-Path: <SRS0=1T4y=43=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EBCC10DCE
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 23:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2515721D56
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 23:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=subitomail.de header.i=@subitomail.de header.b="nmNFv0Fu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgCJXLx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 19:11:53 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:27447 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbgCJXLw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Mar 2020 19:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583881910;
        s=strato-dkim-0002; d=subitomail.de;
        h=Subject:Message-ID:To:From:Date:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=iqIJ/lLkRbB4LX1JmLRnvk4DyTVlA+NO8LF5nqeVycw=;
        b=nmNFv0Fu8ugeXCG5f8QwtxBMJjggw0diO31orgiF1hH9pIIJ7cf3/rWJzEN3BoCxFE
        MtfvIVMssWfX+Bd7Ns3lYoar19ecTNGOo/Cw0SjAtnokMhg+gC4X2F8c/KAytzBq5LLl
        eXvnDtlP//Fc4WOHEjdNLlh79KBXlveoXxU26gGVTEC7jCtTpLdFpjXdviSI9DtCiHtt
        1iEwnNmvA89DqAG7hkLnYjQVivrfDC/ZsujuOAHzOz+RF3jwXa/EYmRogdEboqaXvd8X
        79NZsebKslrB/etikatB+C9jhvDpCegAwjkqyUmL8PF08oDk97j/IrDMfVsRf2JWmgBR
        BluA==
X-RZG-AUTH: ":IW0WYUmmNewgwrC991kQvKMK9+oBpRTyb/PzL5sdOOQmjAEK1c4CTCvEMLIplg3wSVtYZXT0e/DPYlovM5eOhuXh6QlK7MZ1ud2/iMLbo1A2F4vVaLM="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:127.0.0.1]
        by smtp.strato.de (RZmta 46.2.0 AUTH)
        with ESMTPSA id Q02ad6w2AN5kk6C
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Wed, 11 Mar 2020 00:05:46 +0100 (CET)
Date:   Tue, 10 Mar 2020 23:05:49 +0000 (UTC)
From:   Martin <mst1@subitomail.de>
To:     linux-btrfs@vger.kernel.org
Message-ID: <c411f76b-0ac7-4b98-aa90-c8efbb83d3a8@localhost>
Subject: Btrfs not mountable + btrfs Check killed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <c411f76b-0ac7-4b98-aa90-c8efbb83d3a8@localhost>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hi,

My Btrfs on a Readynas is not mountable anymore. I can execute btrfs check with lowmem option only. Without this option it gets killed when checking extents.

Since the man page says, that lowmem is only available for check my question is, whether I have a chance with the repair option?

Would be nice, if somebody could help.

Thanks,
Martin


