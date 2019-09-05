Return-Path: <SRS0=M3o5=XA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E779CC3A5A5
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Sep 2019 13:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 608D4206CD
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Sep 2019 13:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lDWOXLAQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbfIENHB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 09:07:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfIENHA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2019 09:07:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85CxLG7147004;
        Thu, 5 Sep 2019 13:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=rdM+AhGRXfQSf6oCcrC0Jc/xYAuDzRt5ZX42btSTnNQ=;
 b=lDWOXLAQHZ204Ih6Mnu2iFBM+78k+seFAKo5FosSP0WZCw6TvfduJG5RZ2WjnWMxGSV7
 OD750rmSbJQjh2ct/aL9hXBlb2CRSEcCD+RMNKvZZEx2aNi0zGO0Y9Yqwl4Nm8aIpl8v
 jSoZn9Vntq9V3BEN5WsJb49WgiygyNxibGuNXSItZLEWo0/cpDIad2yBE2ZCEnlBE4W+
 CYBMqJ7R0fhSV5GPyqsFu7RYDDnRgA6oT1wcG1e9kVgsKUJv/8xvj6Zl1VOacRs3nXja
 0fiUdPZFsYMcscCK1wvDb9eKlJoy2PonIF22Va1W4ZUFujFCtHNjFpnPzikva22AEyMk Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uu2k4058x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 13:06:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85D3X1a184294;
        Thu, 5 Sep 2019 13:06:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr3hv2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 13:06:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85D6qGH009432;
        Thu, 5 Sep 2019 13:06:52 GMT
Received: from [192.168.1.119] (/39.109.145.141)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 06:06:52 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: Cloning / getting a full backup of a BTRFS filesystem
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <CAJCQCtRCmG05mnTMtxYrnnY5T-gcjiVHP_dYNHSz7NuRrNpLTw@mail.gmail.com>
Date:   Thu, 5 Sep 2019 21:06:43 +0800
Cc:     Anand Jain <anand.jain@oracle.com>,
        =?utf-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F4DE0ABD-51B3-4BBC-B26D-3599A78ED1E4@oracle.com>
References: <7d044ff7-1381-91c8-2491-944df8315305@petaramesh.org>
 <CAJCQCtRCmG05mnTMtxYrnnY5T-gcjiVHP_dYNHSz7NuRrNpLTw@mail.gmail.com>
To:     Chris Murphy <lists@colorremedies.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050128
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> On 5 Sep 2019, at 1:55 AM, Chris Murphy <lists@colorremedies.com> =
wrote:
>=20
> On Wed, Sep 4, 2019 at 12:16 AM Sw=C3=A2mi Petaramesh =
<swami@petaramesh.org> wrote:
>>=20
>> Hi list,
>>=20
>> Is there an advised way to completely =E2=80=9Cclone=E2=80=9D a =
complete BTRFS
>> filesystem, I mean to get an exact copy of a BTRFS filesystem =
including
>> subvolumes (even readonly snapshots) and complete file attributes
>> including extended attributes, ACLs and so, to another storage pool,
>> possibly defined with a different RAID geometry or compression ?
>=20

 Remote replication is a planned feature, when ready, it can be
 used with a local target to meet this requisite.

> The bottom line answer is no. There are only compromises.
>=20
> Btrfs seed sprout will do what you want, except you can't change
> geometry or compression. Last time I tested multiple devices as either
> a source or destination, I ran into problems - but it's possible some
> of this has been fixed, which is a question for Anand Jain.

 Thanks for the report. I just tested the below test case[1],
 it does not fail. Any idea?

[1]
 Create and mount a two devices seed fs, and create a sprout.

 umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb /dev/sdc && =
mount /dev/sdb /btrfs && fillfs /btrfs 100 && umount /btrfs && btrfstune =
-S1 /dev/sdb && mount /dev/sdb /btrfs && btrfs dev add /dev/sdd /btrfs =
&& umount /btrfs

 Mount the sprout device and delete the seed devices to make
 it an independent but identical fs.

 mount /dev/sdd /btrfs && btrfs dev del /dev/sdb /btrfs && btrfs dev del =
/dev/sdc /btrfs

Thanks, Anand





