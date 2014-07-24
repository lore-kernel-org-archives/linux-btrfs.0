Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34483 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759112AbaGXOzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 10:55:52 -0400
Message-ID: <53D11E73.60101@fb.com>
Date: Thu, 24 Jul 2014 10:55:47 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2014 10:48 AM, Liu Bo wrote:
> When failing to allocate space for the whole compressed extent, we'll
> fallback to uncompressed IO, but we've forgotten to redirty the pages
> which belong to this compressed extent, and these 'clean' pages will
> simply skip 'submit' part and go to endio directly, at last we got data
> corruption as we write nothing.

This fallback code was my #1 suspect for the hangs people have been
seeing since 3.15.  I changed things around to trigger the fallback
randomly and wasn't able to trigger problems, but I was looking for
hangs and not corruptions.

-chris


