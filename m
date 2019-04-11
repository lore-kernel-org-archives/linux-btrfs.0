Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC882C10F11
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 01:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CABC217D4
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 01:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d+xcGd/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfDKBru (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 21:47:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33294 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfDKBrt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 21:47:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1hP8G044912;
        Thu, 11 Apr 2019 01:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=L2mjfzPKVRlgpLw0oUCU5QbuEdjk0/sgAkVWIT/QmDs=;
 b=d+xcGd/znf8GLJY+9tdV491V9byMDqtJhYJ4uaWZewr9q1SviNFuNlzJdr3sdWBRC7Vd
 B5Vg/LnoGkznSzDkIwmxcLiq7FebTQSV18/d83FRPPXH0JIOgAsoyX6RuDY8oXjj8d6E
 09F81njQ9e4BdXfug89bq0Le12MpDwgjhs8zSonFtb9+mSgwb/hkLSnNaVI979ukPvcQ
 RLCoqEccLz43K8A/+MNa8V4PNX7kvmV+AeA4DCTfP8ujELnIWPlXAOwZ0cK421k14HXL
 SvqQyMg1zVC1lQNsQ+TuS/m3YenD0A8Dj1d6D9j2++NCzZ87XSGFg7xsHDaeOK1Ktk1Y tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rpkht66xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Apr 2019 01:47:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1juUE151684;
        Thu, 11 Apr 2019 01:47:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2rpkek76qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Apr 2019 01:47:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3B1le10018787;
        Thu, 11 Apr 2019 01:47:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Apr 2019 18:47:40 -0700
Date:   Wed, 10 Apr 2019 18:47:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.de>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] errno.h: Export EFSCORRUPTED error number
Message-ID: <20190411014738.GU15524@magnolia>
References: <20190410083508.21091-1-wqu@suse.com>
 <20190410151134.GG1177@magnolia>
 <eae01c59-2280-69da-1d78-5550e3c47371@suse.de>
 <20190411010628.GT15524@magnolia>
 <89fc7ffb-412f-4e9f-efa2-a624f3ec6a14@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89fc7ffb-412f-4e9f-efa2-a624f3ec6a14@gmx.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9223 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904110011
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9223 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904110011
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 11, 2019 at 09:43:05AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/11 上午9:06, Darrick J. Wong wrote:
> > On Thu, Apr 11, 2019 at 08:28:44AM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2019/4/10 下午11:11,  Darrick J. Wong  wrote:
> >>> On Wed, Apr 10, 2019 at 04:35:07PM +0800, Qu Wenruo wrote:
> >>>> Xfs and Ext* uses EFSCORRUPTED to indicate filesystem corruption.
> >>>> They both map EFSCORRUPTED to EUCLEAN.
> >>>>
> >>>> Btrfs/Ubifs/fscrypto all use EUCLEAN directly to indicate filesystem
> >>>> corruption.
> >>>
> >>> I don't know if you (btrfs folks specifically) care but ext* and xfs
> >>> also use EFSBADCRC to signal unrecovered checksum validation failures.
> >>> Can we promote both of them to asm-generic/errno.h at the same time?
> >>
> >> It looks pretty good to me in fact.
> >>
> >> I'm really tired of using -EIO for csum mismatch/any other higher level
> >> mismatch.
> >>
> >> The only concern is the "CRC" part. Yes, btrfs uses and only supports
> >> CRC32 so far, but I'm sure btrfs will support cryptographic hash.
> >>
> >> So what about renaming it to EFSBADCSUM?
> > 
> > We've been shipping EFSBADCRC in xfslibs-dev userspace libraries for
> > years now, so we can't change the symbol name.
> 
> Fair enough.
> 
> Any extra error number worthy export?

None that I can think of...

--D

> Thanks,
> Qu
> 
> > 
> > --D
> > 
> >> Thanks,
> >> Qu
> >>
> >>>
> >>> #define EFSBADCRC   EBADMSG
> >>>
> >>> --D
> >>>
> >>>> And block layer is going to distinguish filesystem corruption with
> >>>> oridinary EIO error, it's a good idea to export the initial EFSCORRUPTED
> >>>> declaration to <linux/errno.h> so all filesystems and block layer can
> >>>> take advantage of this easier-to-read error number.
> >>>>
> >>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>>> ---
> >>>>  fs/ext2/ext2.h                   | 1 -
> >>>>  fs/ext4/ext4.h                   | 1 -
> >>>>  fs/xfs/xfs_linux.h               | 1 -
> >>>>  include/uapi/asm-generic/errno.h | 3 +++
> >>>>  4 files changed, 3 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> >>>> index 10ab238de9a6..03d0ca8fae42 100644
> >>>> --- a/fs/ext2/ext2.h
> >>>> +++ b/fs/ext2/ext2.h
> >>>> @@ -369,7 +369,6 @@ struct ext2_inode {
> >>>>   */
> >>>>  #define	EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
> >>>>  #define	EXT2_ERROR_FS			0x0002	/* Errors detected */
> >>>> -#define	EFSCORRUPTED			EUCLEAN	/* Filesystem is corrupted */
> >>>>  
> >>>>  /*
> >>>>   * Mount flags
> >>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >>>> index 82ffdacdc7fa..f906b5cbf96d 100644
> >>>> --- a/fs/ext4/ext4.h
> >>>> +++ b/fs/ext4/ext4.h
> >>>> @@ -3248,6 +3248,5 @@ extern const struct iomap_ops ext4_iomap_ops;
> >>>>  #endif	/* __KERNEL__ */
> >>>>  
> >>>>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
> >>>> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
> >>>>  
> >>>>  #endif	/* _EXT4_H */
> >>>> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> >>>> index edbd5a210df2..36e5c6549f15 100644
> >>>> --- a/fs/xfs/xfs_linux.h
> >>>> +++ b/fs/xfs/xfs_linux.h
> >>>> @@ -125,7 +125,6 @@ typedef __u32			xfs_nlink_t;
> >>>>  
> >>>>  #define ENOATTR		ENODATA		/* Attribute not found */
> >>>>  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
> >>>> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
> >>>>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
> >>>>  
> >>>>  #define SYNCHRONIZE()	barrier()
> >>>> diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
> >>>> index cf9c51ac49f9..ebd6e7e76a98 100644
> >>>> --- a/include/uapi/asm-generic/errno.h
> >>>> +++ b/include/uapi/asm-generic/errno.h
> >>>> @@ -98,6 +98,9 @@
> >>>>  #define	EINPROGRESS	115	/* Operation now in progress */
> >>>>  #define	ESTALE		116	/* Stale file handle */
> >>>>  #define	EUCLEAN		117	/* Structure needs cleaning */
> >>>> +
> >>>> +#define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
> >>>> +
> >>>>  #define	ENOTNAM		118	/* Not a XENIX named type file */
> >>>>  #define	ENAVAIL		119	/* No XENIX semaphores available */
> >>>>  #define	EISNAM		120	/* Is a named type file */
> >>>> -- 
> >>>> 2.21.0
> >>>>
> >>>
> >>
> > 
> > 
> > 
> 



