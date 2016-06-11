Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30275 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751909AbcFKNlm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 09:41:42 -0400
Date: Sat, 11 Jun 2016 09:41:05 -0400
From: Chris Mason <clm@fb.com>
To: <jeffm@suse.com>
CC: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs: prefix fsid to all trace events
Message-ID: <20160611134105.bkhh3i5hfcvnkzc7@floor.thefacebook.com>
References: <1465516081-26045-1-git-send-email-jeffm@suse.com>
 <1465516081-26045-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1465516081-26045-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 09, 2016 at 07:48:01PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> When using trace events to debug a problem, it's impossible to determine
> which file system generated a particular event.  This patch adds a
> macro to prefix standard information to the head of a trace event.
> 
> The extent_state alloc/free events are all that's left without an
> fs_info available.

No complaints here.  Do we know of anyone that depends on the current
trace output?

-chris
