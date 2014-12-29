Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41007 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaL2TAG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 14:00:06 -0500
Received: by mail-ie0-f175.google.com with SMTP id x19so12631755ier.20
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 11:00:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
Date: Mon, 29 Dec 2014 13:00:05 -0600
Message-ID: <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
Subject: Re: I need to P. are we almost there yet?
From: "sys.syphus" <syssyphus@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

oh, and sorry to bump myself. but is raid10 *ever* more redundant in
btrfs-speak than raid1? I currently use raid1 but i know in mdadm
speak raid10 means you can lose 2 drives assuming they aren't the
"wrong ones", is it safe to say with btrfs / raid 10 you can only lose
one no matter what?
