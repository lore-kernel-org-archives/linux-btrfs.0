Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45706 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3IRM2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 08:28:33 -0400
Received: by mail-ob0-f170.google.com with SMTP id va2so7517078obc.29
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 05:28:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130916155006.GU6810@twin.jikos.cz>
References: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
	<1379343489-20066-2-git-send-email-ross.kirk@gmail.com>
	<20130916155006.GU6810@twin.jikos.cz>
Date: Wed, 18 Sep 2013 13:28:32 +0100
Message-ID: <CAN_nJPi7K3VR7cw-RsoHYUiwV7QEGpF8J+HyLWHVUtpxMG+nfw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: drop unused parameter from btrfs_item_nr
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 September 2013 16:50, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Sep 16, 2013 at 03:58:09PM +0100, Ross Kirk wrote:
>> Remove unused eb parameter from btrfs_item_nr
>
> Hmm it's been unused since day one
>
> 5f39d397dfbe140a14edecd4e73c34ce23c4f9ee
> Mon Oct 15 16:14:19 2007
>
>> Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>

Do I need to update anything following the Reviewed-by sign off? First
time submitting a patch so still working things out :)

Also should a separate btrfs-progs patch be submitted, as the code is
the same there too?

Thanks

Ross
