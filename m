Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36671 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752921AbaFLAcr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 20:32:47 -0400
Message-ID: <5398F5B9.3000207@fb.com>
Date: Wed, 11 Jun 2014 20:35:05 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix qgroups sanity test crash or hang
References: <1402531956-27668-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1402531956-27668-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/11/2014 08:12 PM, Filipe David Borba Manana wrote:
> Often when running the qgroups sanity test, a crash or a hang happened.
> This is because the extent buffer the test uses for the root node doesn't
> have an header level explicitly set, making it have a random level value.
> This is a problem when it's not zero for the btrfs_search_slot() calls
> the test ends up doing, resulting in crashes or hangs such as the following:
> 

> Therefore initialize the extent buffer as an empty leaf (level 0).
> 
> Issue easy to reproduce when btrfs is built as a module via:
> 
>     $ for ((i = 1; i <= 1000000; i++)); do rmmod btrfs; modprobe btrfs; done

Nice, thanks Filipe, I hadn't been able to trigger this yet.

-chris
