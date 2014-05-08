Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaEHI5H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 04:57:07 -0400
Date: Thu, 8 May 2014 11:05:22 +0200
From: David Disseldorp <ddiss@suse.de>
To: bo.li.liu@oracle.com
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Message-ID: <20140508110522.21930dfd@f163.suse.de>
In-Reply-To: <20140508041123.GB3407@localhost.localdomain>
References: <1399465998-26545-1-git-send-email-ddiss@suse.de>
	<20140508041123.GB3407@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi liubo,

On Thu, 8 May 2014 12:11:24 +0800, Liu Bo wrote:

> Something different here, I didn't get EIO on 3.15.0-rc4.

Strange, I'm able to consistently reproduce this on a
vanilla v3.15-rc4-202-g30321c7 kernel.
Does that mean the updated test passes successfully for you?

Cheers, David
