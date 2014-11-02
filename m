Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:52867 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbaKBWbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 17:31:38 -0500
Message-ID: <5456B0C8.8070402@pobox.com>
Date: Sun, 02 Nov 2014 14:31:36 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Florian Lindner <mailinglists@xgm.de>, linux-btrfs@vger.kernel.org
Subject: Re: Can't mount: open_ctree failed!
References: <m35i04$u5p$1@ger.gmane.org>
In-Reply-To: <m35i04$u5p$1@ger.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2014 07:18 AM, Florian Lindner wrote:
> # btrfsck /dev/sdb1
> # btrfsck --init-extent-tree /dev/sdb1
> # btrfsck --init-csum-tree /dev/sdb1

Notably missing from all these commands is "--repair"...

I don't know that's your problem for sure, but it's where I would start...


