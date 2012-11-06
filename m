Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33713 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2KFDyO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2012 22:54:14 -0500
Message-ID: <509889CF.30302@oracle.com>
Date: Tue, 06 Nov 2012 11:53:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: dave@jikos.cz, Liu Bo <liub.liubo@gmail.com>,
        =?ISO-8859-1?Q?G=E1bor_?= =?ISO-8859-1?Q?Nyers?=
	<gnyers@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: How to find (out if) files sharing content?
References: <20121030162005.0308d5a2@lupus.demo.lan> <5090736C.5040609@oracle.com> <50908D3E.3000609@oracle.com> <20121031113154.GG3102@twin.jikos.cz> <50912157.7090708@oracle.com> <20121105224504.GN3102@twin.jikos.cz>
In-Reply-To: <20121105224504.GN3102@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/06/2012 06:45 AM, David Sterba wrote:
> On Wed, Oct 31, 2012 at 09:02:15PM +0800, Jeff Liu wrote:
>> I propose this because OCFS2 report shared space in this way combine with du(1).
>>
>> An old patch set to teach du(1) aware of reflinked file:
>> https://oss.oracle.com/pipermail/ocfs2-devel/2010-September/007293.html
> 
> Patch looks ok, the shared size is requested by an option.
> 
>> Do you means that the costs is very expensive for userland extent status checkup per file?
> 
> The most expensive part is IMO not in userspace, it does in-memory lookups.
> 
>>> And without any possibility to turn this off,I'm afraid this will render FIEMAP unusable in practice.
>> For OCFS2, the FIEMAP_EXTENT_SHARED flag will be set upon fiemap ioctl(2) if an extent
>> is OCFS2_EXT_REFCOUNTED(i.e. reflinked or cloned), which means that FIEMAP_EXTENT_SHARED
>> is not a persistent flag, but I have no idea how Btrfs would be in this point. :(
> 
> After some research, I think this could work for btrfs without
> unwanted performance penalties.
> 
> There's the fiemap::fm_flags field that can be extended to request the
> shared extent info from fiemap, so the information is not computed
> unconditionally (that was my concern before). The rest is only
> implementation details how to speed up the file extent -> refcount info
> lookups.
Thanks for your confirmation.

-Jeff
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

