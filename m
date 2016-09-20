Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:49504
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754803AbcITQES (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 12:04:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 20 Sep 2016 10:03:11 -0600
From: lakshmipathi.g@giis.co.in
To: dsterba@suse.cz, "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH]btrfs-progs: Add fast,slow symlinks and fifo types to
 convert test
In-Reply-To: <20160919170503.GL16983@twin.jikos.cz>
References: <20160915093407.GA17835@fedori>
 <20160919170503.GL16983@twin.jikos.cz>
Message-ID: <d094623632a3d60468d6ac0cb93ac48b@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-19 11:05, David Sterba wrote:
> On Thu, Sep 15, 2016 at 11:34:07AM +0200, Lakshmipathi.G wrote:
>> +		slow_symlink)
>> +			for num in $(seq 1 $DATASET_SIZE); do
>> +				fname64=`date +%s | sha256sum | cut -f1 -d'-'`
> 
> Do you need to generate the date and sha all the time?
> 

Right, I missed that part. We can create a single file and create 
multiple symlink to that same file. fname64 creation can be moved out of 
the loop. I'll re-send another patch with this fix.


Cheers.
Lakshmipathi.G
