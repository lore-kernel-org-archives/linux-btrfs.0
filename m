Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38C7C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98C4A20855
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=shaw.ca header.i=@shaw.ca header.b="DlBHbysy";
	dkim=pass (2048-bit key) header.d=shaw.ca header.i=@shaw.ca header.b="DlBHbysy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfBKFZy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:25:54 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:48790 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKFZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 00:25:54 -0500
Received: from cds126.dcs.int.inet ([10.0.153.159])
        by shaw.ca with ESMTP
        id t46JgaCE0MRX3t46KgB9Yv; Sun, 10 Feb 2019 22:25:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shaw.ca;
        s=s20180605; t=1549862752;
        bh=E3yBxXBMzfGH7lNwo6f2o7hw88T01BXYuzkqF7Ss/sE=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=DlBHbysyQr+UCdmsck4dWH/84kdPIQeMnjuLV4At+dfdyZlIloG7X15aQj9Ro54ZV
         0Oq8kyKzHWp2uTMOeK4Q17AtYBFV8pwa002LwTbfGJTVea14HftJN1uhrS5jP8FCje
         GVqQOSWEPEM3D0U7HTytGif4UB9Ujm/5cLqSnT2M8Z4shK0kuG79kidumlRtlB/pHM
         PIGwZtgKoJtFyOsXxna4IdQDjT9Dp3itJt0cFNNzOVvx8xg4dcWQRtx9Dk1HiU43Mn
         S6G4wI3Won+I0eCdUilUSHOvTtsiAJuPv12RLR2Bh472FZn6KqvTMOfh5yXV7qUfCn
         Fqo8a+XVPgOVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shaw.ca;
        s=s20180605; t=1549862752;
        bh=E3yBxXBMzfGH7lNwo6f2o7hw88T01BXYuzkqF7Ss/sE=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=DlBHbysyQr+UCdmsck4dWH/84kdPIQeMnjuLV4At+dfdyZlIloG7X15aQj9Ro54ZV
         0Oq8kyKzHWp2uTMOeK4Q17AtYBFV8pwa002LwTbfGJTVea14HftJN1uhrS5jP8FCje
         GVqQOSWEPEM3D0U7HTytGif4UB9Ujm/5cLqSnT2M8Z4shK0kuG79kidumlRtlB/pHM
         PIGwZtgKoJtFyOsXxna4IdQDjT9Dp3itJt0cFNNzOVvx8xg4dcWQRtx9Dk1HiU43Mn
         S6G4wI3Won+I0eCdUilUSHOvTtsiAJuPv12RLR2Bh472FZn6KqvTMOfh5yXV7qUfCn
         Fqo8a+XVPgOVA==
X-Authority-Analysis: v=2.3 cv=TL87tGta c=1 sm=1 tr=0
 a=EkTsUpOA0cE3MUbiN07fnA==:117 a=FKkrIqjQGGEA:10 a=GyfE53u7cosA:10
 a=IkcTkHD0fZMA:10 a=7YfXLusrAAAA:8 a=07d9gI8wAAAA:8 a=q4g7x8XZVFFq838AQ-0A:9
 a=3se_yPmUGMG85XT0:21 a=MXSFQAjVibzdfPX5:21 a=QEXdDO2ut3YA:10
 a=SLz71HocmBbuEhFRYD3r:22 a=e2CUPOnPG4QKp8I52DXD:22
Date:   Sun, 10 Feb 2019 22:25:51 -0700 (MST)
From:   STEVE LEUNG <sjleung@shaw.ca>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <393920696.241868146.1549862751510.JavaMail.zimbra@shaw.ca>
In-Reply-To: <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca> <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [70.73.161.213, 24.68.249.104]
X-Mailer: Zimbra 8.6.0_GA_1240 (ZimbraWebClient - FF64 (Linux)/8.6.0_GA_1240)
Thread-Topic: corruption with multi-device btrfs + single bcache, won't mount
Thread-Index: WpXUB6EB0CvROoCo9qlggOAN3UeZww==
X-CMAE-Envelope: MS4wfPvUTbxOe7YVYnLpossciHKGzj5SfM2fQbqRmytj+y801NI2wF6D3KpZhp66yf2V99zA6OEww58zlnD1I8bprffhWHjDK1knh5jGC2Sp4DqzqxYWaLHA
 Z95XK+av73B206CheBX/R+Cub/mQV7YDMlRE2HUPmFAwEEzGXFX5jY+Y1yKwDFQA78725emaeyJAVvqFIZrMLUd2h6TQ974Q0zs=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



----- Original Message -----
> From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
> On 2019/2/10 =E4=B8=8B=E5=8D=882:56, STEVE LEUNG wrote:
>> Hi all,
>>=20
>> I decided to try something a bit crazy, and try multi-device raid1 btrfs=
 on
>> top of dm-crypt and bcache.  That is:
>>=20
>>   btrfs -> dm-crypt -> bcache -> physical disks
>>=20
>> I have a single cache device in front of 4 disks.  Maybe this wasn't
>> that good of an idea, because the filesystem went read-only a few
>> days after setting it up, and now it won't mount.  I'd been running
>> btrfs on top of 4 dm-crypt-ed disks for some time without any
>> problems, and only added bcache (taking one device out at a time,
>> converting it over, adding it back) recently.
>>=20
> However there is a patch to address this kinda "common" corruption scenar=
io.
>=20
> https://lwn.net/Articles/777265/
>=20
> In that patchset, there is a new rescue=3Dbg_skip mount option (needs to
> be used with ro), which should allow you to access whatever you still
> have from the fs.
>=20
> From other reporters, such corruption is mainly related to extent tree,
> thus data damage should be pretty small.

I can also report that this patch has allowed me to recover the data.
The devices were apparently flaky with the addition of the cache
device to the system, which explains why the filesystem got
corrupted.

Thanks very much for the help!

Steve
