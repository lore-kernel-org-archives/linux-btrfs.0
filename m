Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47771 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3H0BhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 21:37:12 -0400
Received: by mail-lb0-f181.google.com with SMTP id u14so2085490lbd.12
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 18:37:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201308241809.58701.thomas@koch.ro>
References: <201308241809.58701.thomas@koch.ro>
Date: Mon, 26 Aug 2013 21:37:10 -0400
Message-ID: <CAAdM644B0z_0_emTez8c05p4gkLQNK2GcFtthYgzpMh+Po4sXg@mail.gmail.com>
Subject: Re: check for reflink capability and for shared data
From: Marios Titas <redneb8888@gmail.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 24, 2013 at 12:09 PM, Thomas Koch <thomas@koch.ro> wrote:
> - check whether two files share the same data on disk, i.e. one has been
> created by cp --reflink of the other?

How about inspecting the output of filefrag -v $filename?
For example, you could filter out with grep all lines except the ones
that contain information about the extents.
Then you could hash the lines left and use that single hash to compare
the two files.
