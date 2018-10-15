Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DA0C71132
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 16:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CC9E2089D
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 16:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T742lFaQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CC9E2089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbeJPAQV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 20:16:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbeJPAQU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 20:16:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9FGT9mr164841;
        Mon, 15 Oct 2018 16:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=5rPpfIp8gIZINM8DbZIUGtk4yiXQdL1UwGYsS76z6og=;
 b=T742lFaQhWzpjRU4FHC5XZiOjn0m8mMcqtUMnxbuIl6o/j7ZTjO3FzUwHS0JtAtTlLIb
 nu4KsYD9rqdcNkMf9VRA9zjJycp9BSvKgPWfAXbbJ29s7q6RvgRsUB9BS1nJykbDBBuK
 2he3tIpRkU5YyL4V9cylXuGGasU6xkYIZUy+9LKcUEgeRQ9y0V3AZzpKeSw+yKVHoy+v
 qhEALT3NJUcCxpUHWDRfFCNf5YwQnswqiz/GOFKbQ8KQSiKh9m7s/tJLOMw/OlEkgrh3
 WILnjskjmzKtfzLQKcTBZnnPZOwCp0+8tWEM/qLFXKCGLoHAhkMrkprS0XedlCiD6t03 2w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2n38npujd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 16:30:05 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9FGU48Q003614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 16:30:04 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9FGU3ij029903;
        Mon, 15 Oct 2018 16:30:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 09:30:02 -0700
Date:   Mon, 15 Oct 2018 09:30:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 10/25] vfs: create generic_remap_file_range_touch to
 update inode metadata
Message-ID: <20181015163001.GK28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921180.8361.13556945128095535605.stgit@magnolia>
 <20181014172131.GE30673@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014172131.GE30673@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=997
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810150146
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 14, 2018 at 10:21:31AM -0700, Christoph Hellwig wrote:
> > +/* Update inode timestamps and remove security privileges when remapping. */
> > +int generic_remap_file_range_touch(struct file *file, bool is_dedupe)
> > +{
> > +	int ret;
> > +
> > +	/* If can't alter the file contents, we're done. */
> > +	if (is_dedupe)
> > +		return 0;
> > +
> > +	/* Update the timestamps, since we can alter file contents. */
> > +	if (!(file->f_mode & FMODE_NOCMTIME)) {
> > +		ret = file_update_time(file);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	/*
> > +	 * Clear the security bits if the process is not being run by root.
> > +	 * This keeps people from modifying setuid and setgid binaries.
> > +	 */
> > +	return file_remove_privs(file);
> > +}
> > +EXPORT_SYMBOL(generic_remap_file_range_touch);
> 
> The name seems a little out of touch with what it actually does.

I originally thought "touch" because it updates [cm]time. :)

Though looking at the final code, I think this can just be called from
the end of generic_remap_file_range_prep, so we can skip the export and
all that other stuff.

> Also why a bool argument instead of the more descriptive flags which
> introduced a few patches ago?

Hmm, yes, the remap_flags transition can move up to before this patch.

--D
