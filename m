Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([212.48.14.163]:44319 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752111AbdHRQXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 12:23:21 -0400
Reply-To: kreijack@inwind.it
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Josef Bacik <josef@toxicpanda.com>,
        Paulo Dias <paulo.miguel.dias@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <20170817233916.GA25527@destiny>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <ceb36a9a-b73f-96c1-cb58-24f149b24001@libero.it>
Date: Fri, 18 Aug 2017 18:23:18 +0200
MIME-Version: 1.0
In-Reply-To: <20170817233916.GA25527@destiny>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2017 01:39 AM, Josef Bacik wrote:
[...]
> This is happening because the app (the guest OS in this case, we saw this a lot
> with windows guests) is changing the pages while they are in flight.  We
> calculate the checksum of the page before it's written, so if it changes while
> in flight we'll end up with a csum mismatch.
> 
> To fix this change kvm to not use O_DIRECT or set NODATASUM on your qcow2 image.
> You'll have to re-create the image because NODATASUM won't apply to the already
> invalid checksums.  Thanks,

Hi Josef,

could you elaborate: do you are saying that using O_DIRECT is incompatible with DATASUM ?

Let me know

BR
G.Baroncelli

> 
> Josef 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
