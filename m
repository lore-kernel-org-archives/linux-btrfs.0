Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63235 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752930AbcFCOC4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 10:02:56 -0400
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
CC: <dsterba@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <3b5ed9c3-7ffd-4bcf-5992-e11b7f6463a5@fb.com>
Date: Fri, 3 Jun 2016 10:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/01/2016 01:48 AM, Lu Fengqi wrote:
> Only in the case of different root_id or different object_id, check_shared
> identified extent as the shared. However, If a extent was referred by
> different offset of same file, it should also be identified as shared.
> In addition, check_shared's loop scale is at least  n^3, so if a extent
> has too many references,  even causes soft hang up.
>
> First, add all delayed_ref to the ref_tree and calculate the unqiue_refs,
> if the unique_refs is greater than one, return BACKREF_FOUND_SHARED.
> Then individually add the  on-disk reference(inline/keyed) to the ref_tree
> and calculate the unique_refs of the ref_tree to check if the unique_refs
> is greater than one.Because once there are two references to return
> SHARED, so the time complexity is close to the constant.
>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

This is a lot of work for just wanting to know if something is shared. 
Instead lets adjust this slightly.  Instead of passing down a 
root_objectid/inum and noticing this and returned shared, add a new way 
to iterate refs.  Currently we go gather all the refs and then do the 
iterate dance, which is what takes so long.  So instead add another 
helper that calls the provided function every time it has a match, and 
then we can pass in whatever context we want, and we return when 
something matches.  This way we don't have all this extra accounting, 
and we're no longer passing root_objectid/inum around and testing for 
some magic scenario.  Thanks,

Josef

