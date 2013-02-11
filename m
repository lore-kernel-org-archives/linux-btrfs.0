Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44025 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab3BKNY2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 08:24:28 -0500
Received: by mail-ie0-f179.google.com with SMTP id k11so7605256iea.10
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 05:24:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130211124928.GM12339@twin.jikos.cz>
References: <CACP9TETrrxT=HyvXWt+uBDXjW9o9LGvJdrAPpUmzy4nb5iWXwQ@mail.gmail.com>
	<CACP9TETFnG2T3jqaOTRtLkrPV2TMiUn5bNdQoQfGEFzmwH18DA@mail.gmail.com>
	<20130211124928.GM12339@twin.jikos.cz>
Date: Mon, 11 Feb 2013 17:24:28 +0400
Message-ID: <CACP9TEQgCjgNSEyCe0mJ8yNT8QhxzW2aLPkkBCdhQE3u_ozzog@mail.gmail.com>
Subject: Re: Raid1 not working as expected
From: Alexey Polyakov <alexey.polyakov@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 4:49 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Feb 11, 2013 at 04:28:43PM +0400, Alexey Polyakov wrote:
>
> Did you use a kernel version between 3.8-rc1 and 3.8-rc5 ?

I used 3.8-rc6 and 3.8-rc7 when working with fs in question, but also
I mounted it under kernel that Ubuntu ships, version number is 3.8.0-4
- I'm not sure which vanilla version it is based on.

--
Alexey
