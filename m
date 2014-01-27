Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:40644 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaA0TKz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 14:10:55 -0500
Message-ID: <52E6AF3C.1070401@libero.it>
Date: Mon, 27 Jan 2014 20:10:52 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Gerhard Heift <gerhard@heift.name>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2] new ioctl TREE_SEARCH_V2
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2014-01-27 14:28, Gerhard Heift wrote:
> This patch series adds a new ioctl TREE_SEARCH_V2 with which we could store the
> results in a varying buffer. Now even items larger than 3992 bytes or a large
> amount of items can be returned.


One of the main strangeness of the current TREE_SEARCH ioctl, which I
found is the fact that the search was not in a "rectangular" region, but
in a "linear" region.

This is due the fact that after a ioctl call, we have to set the min_*
fields with the sh->{objectid,offset,type} +1 rounding to 0 if case of
overflow.

This because the min_* fields are both the "lower bound" of the search
and the "starting point" of the next search. Adding a new set of fields
named start_* could solve this issue.

I discussed this topic few years ago in [1].

Because we are introducing a new ioctl, is it possible to solve this
issue ? We could avoid some userspace<->kernelspace transition, which
seems be one of the goal of your patch.

BR
G.Baroncelli



[1] http://www.spinics.net/lists/linux-btrfs/msg07617.html



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
