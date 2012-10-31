Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:19180 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab2JaNEB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 09:04:01 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9VD40Be001155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 13:04:00 GMT
Message-ID: <50912157.7090708@oracle.com>
Date: Wed, 31 Oct 2012 21:02:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: dave@jikos.cz
CC: Liu Bo <liub.liubo@gmail.com>,
        =?ISO-8859-1?Q?G=E1bor_Nyers?= <gnyers@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: How to find (out if) files sharing content?
References: <20121030162005.0308d5a2@lupus.demo.lan> <5090736C.5040609@oracle.com> <50908D3E.3000609@oracle.com> <20121031113154.GG3102@twin.jikos.cz>
In-Reply-To: <20121031113154.GG3102@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 07:31 PM, David Sterba wrote:
> On Wed, Oct 31, 2012 at 10:30:22AM +0800, Jeff Liu wrote:
>> One idea is to mark those cloned extents as FIEMAP_EXTENT_SHARED so that
>> we can go through a file to figure out how many extents are shared
>> through fiemap(2), and calculate the real storage(fs/subvolume) footprint
>> in the end.
> 
> This will cost at least one more seek per extent to find out that the
> extent is shared, could be quite expensive.
I propose this because OCFS2 report shared space in this way combine with du(1).

An old patch set to teach du(1) aware of reflinked file:
https://oss.oracle.com/pipermail/ocfs2-devel/2010-September/007293.html

Do you means that the costs is very expensive for userland extent status checkup per file?
If yes, I have once tested an 50Gb OCFS2 partition filled with reflinked files on an old laptop,
it spent around 4 minutes to show the totally results if I recalled correct, but this definitely
depending on the real world scenarios.

> And without any possibility to turn this off,I'm afraid this will render FIEMAP unusable in practice.
For OCFS2, the FIEMAP_EXTENT_SHARED flag will be set upon fiemap ioctl(2) if an extent
is OCFS2_EXT_REFCOUNTED(i.e. reflinked or cloned), which means that FIEMAP_EXTENT_SHARED
is not a persistent flag, but I have no idea how Btrfs would be in this point. :(

Thanks,
-Jeff
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

