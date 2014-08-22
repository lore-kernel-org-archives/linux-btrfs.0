Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429AbaHVRca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 13:32:30 -0400
Message-ID: <53F77EAB.5070309@redhat.com>
Date: Fri, 22 Aug 2014 12:32:27 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted
 in various ways
References: <20140822155040.GU3875@merlins.org>
In-Reply-To: <20140822155040.GU3875@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/22/14, 10:50 AM, Marc MERLIN wrote:

> But if my kernel hangs due to a bug that isn't btrfs' fault and I need
> to power off and back on, after reboot my google-chrome profile is
> almost always broken in some way.

Given my experiences with userspace in general, I'd lay money on
google-chrome simply not DTRT WRT data integrity syscalls (or
maybe it's the sqlite database handling underneath...)

Does it behave any differently on other filesystems?

-Eric

