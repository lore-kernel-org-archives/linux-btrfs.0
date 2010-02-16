From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Tue, 16 Feb 2010 14:28:00 -0500
Message-ID: <4B7AF1C0.6030904@gmail.com>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100212192804.GE4191@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On Wed, Feb 10, 2010 at 01:53:50PM -0500, jim owens wrote:
>> +
>> +static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len)
>> +{
>> +	int err = 0;
>> +	diocb->umc.todo = hole_len;
>> +	while (diocb->umc.todo) {
>> +		struct bio_vec uv;
>> +		char *out;
>> +
>> +		err = btrfs_dio_get_user_bvec(&uv, &diocb->umc);
>> +		if (err)
>> +			goto fail;
>> +		diocb->start += uv.bv_len;
>> +		out = kmap_atomic(uv.bv_page, KM_USER0);
>> +		memset(out + uv.bv_offset, 0, uv.bv_len);
>> +		kunmap_atomic(out, KM_USER0);
>> +
> 
> /me hands jim a zero_user_page()
> 
>> +		btrfs_dio_done_with_out(&uv, NULL);
>> +	}

As promised... why I'm keeping my code :)

cscope says there is no zero_user_page() so I think
you mean the same one I looked at zero_user(), which
calls the far more complicated zero_user_segments().

I did not use it for 3 reasons:

1) More generated code (but maybe gcc reduces it).

2) My btrfs_dio_done_with_out() must do (so repeat) the
flush_dcache_page which is not a noop on every arch.

3) Everywhere else in btrfs does the same as my code.

jim
