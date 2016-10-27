Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56989 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933208AbcJ0AA5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 20:00:57 -0400
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
From: Jens Axboe <axboe@fb.com>
Message-ID: <b18208b6-f2f4-ddbb-a5b9-1c90ac7321f5@fb.com>
Date: Wed, 26 Oct 2016 18:00:34 -0600
MIME-Version: 1.0
In-Reply-To: <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2016 05:47 PM, Dave Jones wrote:
> On Wed, Oct 26, 2016 at 07:38:08PM -0400, Chris Mason wrote:
>
>  > >-	hctx->queued++;
>  > >-	data->hctx = hctx;
>  > >-	data->ctx = ctx;
>  > >+	data->hctx = alloc_data.hctx;
>  > >+	data->ctx = alloc_data.ctx;
>  > >+	data->hctx->queued++;
>  > > 	return rq;
>  > > }
>  >
>  > This made it through an entire dbench 2048 run on btrfs.  My script has
>  > it running in a loop, but this is farther than I've gotten before.
>  > Looking great so far.
>
> Fixed the splat during boot for me too.
> Now the fun part, let's see if it fixed the 'weird shit' that Trinity
> was stumbling on.

Let's let the testing simmer overnight, then I'll turn this into a real
patch tomorrow and get it submitted.

-- 
Jens Axboe

