Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26355 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759443AbaGXVZO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 17:25:14 -0400
Message-ID: <53D179B3.6010800@fb.com>
Date: Thu, 24 Jul 2014 17:25:07 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs: refactor open_ctree()
References: <53AB6185.9060109@redhat.com>
In-Reply-To: <53AB6185.9060109@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2014 07:55 PM, Eric Sandeen wrote:
> First off: total RFC, don't merge this; it builds, but
> is totally untested.
> 
> open_ctree() is almost 1000 lines long.  I've started trying
> to refactor it, primarily into helper functions, and also
> simplifying (?) things a bit at the beginning by removing the
> ret = func(); if (ret) { err = ret; goto ... } dance where it's not
> needed.
> 
> Does this look like a reasonable thing to do?  Have I cut
> things into the right chunks?  Would you rather see it as
> as series of patches, moving one hunk of code at a time?

I do love this patch, either as a series or one big patch.  Whatever
makes it easiest for you to test is fine with me.

-chris
