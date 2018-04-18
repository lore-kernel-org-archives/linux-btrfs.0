Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753115AbeDRXJv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 19:09:51 -0400
Subject: Re: [PATCH 2/2] btrfs: optimize free space tree bitmap conversion
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <kernel-team@fb.com>
References: <20180418213059.8025-1-hmclauchlan@fb.com>
 <20180418213059.8025-2-hmclauchlan@fb.com>
 <20180418222606.GX21272@twin.jikos.cz>
From: Howard McLauchlan <hmclauchlan@fb.com>
Message-ID: <afad2b1a-d4cb-458a-bbce-145ae49d9670@fb.com>
Date: Wed, 18 Apr 2018 16:09:13 -0700
MIME-Version: 1.0
In-Reply-To: <20180418222606.GX21272@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/18/2018 03:26 PM, David Sterba wrote:
> On Wed, Apr 18, 2018 at 02:30:59PM -0700, Howard McLauchlan wrote:
>> Presently, convert_free_space_to_extents() does a linear scan of the
>> bitmap. We can speed this up with find_next_{bit,zero_bit}_le().
>>
>> This patch replaces the linear scan with find_next_{bit,zero_bit}_le().
>> Testing shows a 20-33% decrease in execution time for
>> convert_free_space_to_extents().
>>
>> Suggested-by: Omar Sandoval <osandov@osandov.com>
>> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
>> ---
>>
>> Since we change bitmap to be unsigned long, we have to do some casting for the
>> bitmap cursor. In le_bitmap_set() it makes sense to use u8, as we are doing
>> bit operations. Everywhere else, we're just using it for pointer arithmetic and
>> not directly accessing it, so char seems more appropriate.
> Ok, makes sense for just passing the pointers around. I'll add the text
> to changelog and apply the patch to next.
>
>> -		bit = !!le_test_bit(bitnr, bitmap);
> This is the last use of le_test_bit, so it can be removed (in another
> patch).
I just found an issue in this patch that should be fixed. I'll address
moving le_bitmap_set(), le_test_bit and send a V2 for both these patches.

Howard
