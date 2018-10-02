Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C235EC43143
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 15:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A6B22082A
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 15:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YKUwFyNm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A6B22082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbeJBWDe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 18:03:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbeJBWDd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2018 18:03:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w92FDeTh128081;
        Tue, 2 Oct 2018 15:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=j/hwbBOv4Abano2KNTJQQ/f0amGUJD2nimZDho4QYHo=;
 b=YKUwFyNmhMhSMxkLVCe0UYoWgNIIbaty4CAngVdIJXl+UW9Rlh7mb3bQdpOaCnYrWhmS
 KjJxFrzTcjiZU0cD167aNga85Gz5/mWh1ZhCtT9t8vRM/RI28rZafAPU75Q4og+Zsv4m
 kWMAkYFB5t6kw8tqgXsYvXASu65/yp8nANWjPlMeK1WMwwVoWHlZ0BY03ajNqfIkAGFa
 stuE1axWW+rHF/bONmmSgOQxzEUC38q5HJqGNv/SCgZmo2Y5Q2rT3kVQGO0peeD2cuSu
 xpFwn9Y0Qw6JmB+Xb73MzqJiajjUrHqbk1byoQRWjNmfMKG2EoNuM+KDSnz5WdEu55dA 0w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mt1bpxbkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Oct 2018 15:19:30 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w92FJTCn031202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Oct 2018 15:19:29 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w92FJSTp014020;
        Tue, 2 Oct 2018 15:19:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Oct 2018 08:19:27 -0700
Date:   Tue, 2 Oct 2018 08:19:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     dsterba@suse.cz, Andreas Dilger <adilger@dilger.ca>,
        Eric Sandeen <sandeen@sandeen.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: cross-fs copy support
Message-ID: <20181002151926.GC6706@magnolia>
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
 <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
 <FE6394EC-5CB0-4A16-AAC6-97F465A4E50C@dilger.ca>
 <20181002081544.GW3255@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002081544.GW3255@twin.jikos.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9033 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810020148
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 02, 2018 at 10:15:44AM +0200, David Sterba wrote:
> On Mon, Oct 01, 2018 at 01:51:09PM -0600, Andreas Dilger wrote:
> > > Yes, I would expect there to be problems with his modified kernel
> > > for a filesystem that supports clone_file_range, because
> > > vfs_copy_file_range() will clone if possible, and this should fail across
> > > filesystems.
> > > 
> > > In general, though, I don't know for sure why we don't fall back to
> > > do_splice_direct() across filesystems, although the filesystems that
> > > implement their own ->copy_file_range ops may have their own,
> > > further restrictions within their implementations.
> > > 
> > > This call /is/ documented in the manpage as only being valid for
> > > files on the same filesystem, though:
> > > http://man7.org/linux/man-pages/man2/copy_file_range.2.html
> > 
> > There was a patch to allow cross-mount copy for NFS, but it hasn't landed
> > yet.
> 
> I found https://marc.info/?l=linux-nfs&m=144138779721907&w=2 that lifts
> the VFS check (part of a series that can't be easily linked to).
> 
> The lack of cross-mount reflink (based on the copy_file_ragne) is often
> confusing users, there are common setups that mount subvolumes
> separately and reflinking between them would require mount of the
> toplevel subvolume.
> 
> If there are 2 in-kernel users of the relaxed cross-mount copy, I think
> this would help to push the series forward.

I don't have any objection to cross-mountpoint same-filesystem clones,
though obviously we need to all agree that from now on the vfs /does/
support certain IO operations across mountpoints.

(I haven't any opinion on cross-filesystem copies, as XFS is incapable
of such things.)

--D
