Return-Path: <SRS0=kkXa=DX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CBBC433E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84DA520E65
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=waffle.tech header.i=@waffle.tech header.b="vG0nbkCZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390256AbgJPR23 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 13:28:29 -0400
Received: from waffle.tech ([104.225.250.114]:55820 "EHLO mx.waffle.tech"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732302AbgJPR23 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Oct 2020 13:28:29 -0400
Received: from mx.waffle.tech (unknown [10.50.1.6])
        by mx.waffle.tech (Postfix) with ESMTP id B4B5D6D83F;
        Fri, 16 Oct 2020 11:28:25 -0600 (MDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.waffle.tech B4B5D6D83F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=waffle.tech; s=mx;
        t=1602869305; bh=7gDokWNtlCIql3XPSjEbsVQMzAYXv2qzdNF8csijA2s=;
        h=Date:From:Subject:To:In-Reply-To:References:From;
        b=vG0nbkCZ/R+BIfOoes7NXKASH7QPIiUdfQeCBANxHfcl9zaHS92wdfo0BvkjiypwC
         +NPshlLGR8KhfA0dQgleDLKBeqJj9+HFcDRyVQRQDAEXC+L6EoLmX9a+3+SHHXE36v
         Pl5RSUcZa7uhECJiSW+fCy4+hIeLyGJpKV8vlsp0=
Received: from waffle.tech ([10.50.1.3])
        by mx.waffle.tech with ESMTPSA
        id HSviKjnYiV/7agcAQqPLoA
        (envelope-from <louis@waffle.tech>); Fri, 16 Oct 2020 11:28:25 -0600
MIME-Version: 1.0
Date:   Fri, 16 Oct 2020 17:28:24 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.14.0
From:   louis@waffle.tech
Message-ID: <e954bedcb5647369753424177dc63928@waffle.tech>
Subject: Re: [PATCH] btrfs: balance RAID1/RAID10 mirror selection
To:     "Qu Wenruo" <quwenruo.btrfs@gmx.com>,
        "Nikolay Borisov" <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        "Anand Jain" <anand.jain@oracle.com>
In-Reply-To: <b4f37e58-496d-818a-35d9-ab0832a6fe61@gmx.com>
References: <b4f37e58-496d-818a-35d9-ab0832a6fe61@gmx.com>
 <8541d6d7a63e470b9f4c22ba95cd64fc@waffle.tech>
 <4226ff1b-e313-2881-0670-965e7e98ce59@suse.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

October 16, 2020 1:29 AM, "Qu Wenruo" <quwenruo.btrfs@gmx.com> wrote:=0A=
=0A> On 2020/10/16 =E4=B8=8B=E5=8D=883:15, Nikolay Borisov wrote:=0A> =0A=
>> On 16.10.20 =D0=B3. 8:59 =D1=87., louis@waffle.tech wrote:=0A>>> Balan=
ce RAID1/RAID10 mirror selection via plain round-robin scheduling. This s=
hould roughly double=0A>>> throughput for large reads.=0A>>> =0A>>> Signe=
d-off-by: Louis Jencka <louis@waffle.tech>=0A>> =0A>> Can you show number=
s substantiating your claims?=0A> =0A> And isn't this related to the read=
 policy? IIRC some patches are=0A> floating in the mail list to provide t=
he framework of how the read=0A> policy should work.=0A> =0A> Those patch=
es aren't yet merged?=0A> =0A> Thanks,=0A> Qu=0A=0AOh, I hadn't seen the =
read-policy framework thread. Within that, this could be=0Aa new policy o=
r a replacement for BTRFS_READ_POLICY_PID. Is work ongoing for=0Athose pa=
tches?=0A=0ALouis
