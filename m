Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1668C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 06:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA7520863
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 06:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=shaw.ca header.i=@shaw.ca header.b="M4D1y3Zj";
	dkim=pass (2048-bit key) header.d=shaw.ca header.i=@shaw.ca header.b="M4D1y3Zj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfBLGWU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 01:22:20 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:51308 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBLGWU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 01:22:20 -0500
Received: from cds126.dcs.int.inet ([10.0.153.159])
        by shaw.ca with ESMTP
        id tRSTg6VFu8uQmtRSUgmU9j; Mon, 11 Feb 2019 23:22:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shaw.ca;
        s=s20180605; t=1549952538;
        bh=FY7HUCD7ngBVZHYVfmWpOeLF4Iq1SYsj2j8AKfyghuc=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=M4D1y3ZjEXZScoUa8pVZ/ZdBd2CaZrmDbkxcKaycXRJ4y/ffGW7V6peTHlX2quwNt
         fURjn9NN0XsH+WpqZBf/GRv18wr/RpZ66dVn8ZOqb4j/3RJKU/GjUSohNKuKULwZ4N
         knklKGGPa7fjVVI+atXH4Z3mGDQcYbV+EL8yvtq2kkdEDdvi/rzLXeh9UHBC6wSEXp
         xeTCr6pJ2aG7umJCdDmhmpxmt4pVnyKuTQ/ZhoqQBTBdJhB1UwcMa5rd15qZa+UBTs
         zT5FLkCNJKijkjEz/Va+G54PIrx2KWZFbqX8REyko/VQtWc4hAuBeDx55OOl5RFZ95
         IeAa0nz+pdj0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shaw.ca;
        s=s20180605; t=1549952538;
        bh=FY7HUCD7ngBVZHYVfmWpOeLF4Iq1SYsj2j8AKfyghuc=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=M4D1y3ZjEXZScoUa8pVZ/ZdBd2CaZrmDbkxcKaycXRJ4y/ffGW7V6peTHlX2quwNt
         fURjn9NN0XsH+WpqZBf/GRv18wr/RpZ66dVn8ZOqb4j/3RJKU/GjUSohNKuKULwZ4N
         knklKGGPa7fjVVI+atXH4Z3mGDQcYbV+EL8yvtq2kkdEDdvi/rzLXeh9UHBC6wSEXp
         xeTCr6pJ2aG7umJCdDmhmpxmt4pVnyKuTQ/ZhoqQBTBdJhB1UwcMa5rd15qZa+UBTs
         zT5FLkCNJKijkjEz/Va+G54PIrx2KWZFbqX8REyko/VQtWc4hAuBeDx55OOl5RFZ95
         IeAa0nz+pdj0Q==
X-Authority-Analysis: v=2.3 cv=XKpOtjpE c=1 sm=1 tr=0
 a=EkTsUpOA0cE3MUbiN07fnA==:117 a=FKkrIqjQGGEA:10 a=GyfE53u7cosA:10
 a=IkcTkHD0fZMA:10 a=7YfXLusrAAAA:8 a=_Dj-zB-qAAAA:8 a=VwQbUJbxAAAA:8
 a=07d9gI8wAAAA:8 a=mb3WWMwt0e6coX8IEl4A:9 a=67kSNYC9qnAL8-n2:21
 a=inlwD1vzG3_dbpPE:21 a=QEXdDO2ut3YA:10 a=SLz71HocmBbuEhFRYD3r:22
 a=c-cOe7UV8MviEfHuAVEQ:22 a=AjGcO6oz07-iQ99wixmX:22 a=e2CUPOnPG4QKp8I52DXD:22
Date:   Mon, 11 Feb 2019 23:22:17 -0700 (MST)
From:   Steve Leung <sjleung@shaw.ca>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <902519958.253211268.1549952537314.JavaMail.zimbra@shaw.ca>
In-Reply-To: <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca> <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [70.73.161.213, 207.35.36.18]
X-Mailer: Zimbra 8.6.0_GA_1240 (ZimbraWebClient - FF64 (Linux)/8.6.0_GA_1240)
Thread-Topic: corruption with multi-device btrfs + single bcache, won't mount
Thread-Index: CogYjeiyh7UNia0q0W67QwlQAMCGxw==
X-CMAE-Envelope: MS4wfLhYKsTIoEamKJ9t9pwQSRXaHV1djyyNv64pK4DnCPkARYp9IFJ7P8sCVs5l4mRGHyvf3ZQmjoO3S96IIjVn5ZyfUJM7ftBPX0B1yT/va+wev2PUZqHo
 HnTGIvSrpbi5hEeMOiiR7+UZ6vLQw4OuslfUx8rWrmQjZ9Y9RipuKy1/vrwjYcN2vNlP4xyujz4FRxReuHuH7haDiqxRwA+AGdU=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



----- Original Message -----
> From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
> To: "STEVE LEUNG" <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
> Sent: Sunday, February 10, 2019 6:52:23 AM
> Subject: Re: corruption with multi-device btrfs + single bcache, won't mo=
unt

> ----- Original Message -----
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
>> This was on Arch Linux x86-64, kernel 4.20.1.
>>=20
>> dmesg from a mount attempt (using -o usebackuproot,nospace_cache,clear_c=
ache):
>>=20
>>   [  267.355024] BTRFS info (device dm-5): trying to use backup root at =
mount time
>>   [  267.355027] BTRFS info (device dm-5): force clearing of disk cache
>>   [  267.355030] BTRFS info (device dm-5): disabling disk space caching
>>   [  267.355032] BTRFS info (device dm-5): has skinny extents
>>   [  271.446808] BTRFS error (device dm-5): parent transid verify failed=
 on
>>   13069706166272 wanted 4196588 found 4196585
>>   [  271.447485] BTRFS error (device dm-5): parent transid verify failed=
 on
>>   13069706166272 wanted 4196588 found 4196585
>=20
> When this happens, there is no good way to completely recover (btrfs
> check pass after the recovery) the fs.
>=20
> We should enhance btrfs-progs to handle it, but it will take some time.
>=20
>>   [  271.447491] BTRFS error (device dm-5): failed to read block groups:=
 -5
>>   [  271.455868] BTRFS error (device dm-5): open_ctree failed
>>=20
>> btrfs check:
>>=20
>>   parent transid verify failed on 13069706166272 wanted 4196588 found 41=
96585
>>   parent transid verify failed on 13069706166272 wanted 4196588 found 41=
96585
>>   parent transid verify failed on 13069706166272 wanted 4196588 found 41=
96585
>>   parent transid verify failed on 13069706166272 wanted 4196588 found 41=
96585
>>   Ignoring transid failure
>>   ERROR: child eb corrupted: parent bytenr=3D13069708722176 item=3D7 par=
ent level=3D2
>>   child level=3D0
>>   ERROR: cannot open file system
>>=20
>> Any simple fix for the filesystem?  It'd be nice to recover the data
>> that's hopefully still intact.  I have some backups that I can dust
>> off if it really comes down to it, but it's more convenient to
>> recover the data in-place.
>=20
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

Ok I think I spoke too soon.  Some files are recoverable, but many
cannot be read.  Userspace gets back an I/O error, and the kernel log
reports similar parent transid verify failed errors, with what seem
to be similar generation numbers to what I saw in my original mount
error.

i.e. wants 4196588, found something that's off by usually 2 or 3.
Occasionally there's one that's off by about 1300.

There are multiple snapshots on this filesystem (going back a few
days), and the same file in each snapshot seems to be equally
affected, even if the file hasn't changed in many months.

Metadata seems to be intact - I can stat every file in one of the
snapshots and I don't get any errors back.

Any other ideas?  It kind of seems like "btrfs restore" would be
suitable here, but it sounds like it would need to be taught about
rescue=3Dbg_skip first.

Thanks for all the help.  Even a partial recovery is a lot better
than what I was facing before.

Steve
