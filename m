Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794345303;
	b=MRcdrvVnKE/7mbGU7YNTbPEcPkmhhEP0+EZl/5h4XRLHLDVTL2ZvvHF5IUE5wqM0Uz1L
	 OVcEc3SIhwO9qyydkOG7e0zDkO7vHoASfi3ubJVPIdF6WLNQHafC5x/FSfW+ysk/VmGmx
	 2pQS95YdqgBbSRM74QNC89KM4xo5nmnNZZj5d4BB6Q3QdvfnJVbDlJQxe9v5FrdlmwL70
	 vWf5I3015z4CxilqQXE0CbG+dKprLsQznsHk5qXJG6wnJKpZG68WmOmeKUbFKYOGSwk7c
	 YRo6sO7hKQzUVEO3dhBAMLGmZqfGqxtILYcUFZihcBUy9Hk72otIfh1s8tLsJdqy5RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794345303;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=nVARVyMM/7IfHWnXWeKDkhlyad2D80c3nx61nuy3dUo=;
	b=ZVnbLmNiKPonqnHyfMZ/6FJC2I495SoUh0T/IBt2wJBvb5WP2EULkbBtKFuzM7SsQeUz
	 E4IpArbz2fdF8HZoesKxmaBOiC31oLwrnL0LvpiDeuWsOyDUm65Rt5Qgh8O7zAmgcn27h
	 uidoYGcmpCCoR6gQil5VDPwIPABxZp4Bq05PF3MzV2HtYWLWJmS+8M+lGxkwJzY/2V2hO
	 6mHNKYQtAqUYcoEMKv7jLCvRimhtPlS9Z5QT5OeYu2rd4/EcKidvR0d5QG2DfBEBnDMPY
	 WKdKYiUdRJUGOMYB6eIcBNWFO6UPc/Nv9EmEp2mwjttBcV34+vBp8Ss2oyWm4alqsIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LGVYltrY;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60350606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 21:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60350606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LGVYltrY
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so30618345e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 13:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794345301; x=1794950101; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nVARVyMM/7IfHWnXWeKDkhlyad2D80c3nx61nuy3dUo=;
        b=LGVYltrYTJSBqJQ16JFNY9M5k6usX34WVr8KHF0BrAOgn6Sadz6xYSjfK+TNRa/2c1
         OLgQd2aqThoYZya2pI1TW4v2hh3Ls3VNjy2P9ZKJDcxy/hxhTdQClx1o0zb3XMNlJqyZ
         0dRvhduoCVLJH7O2jNpzGj06Ng9n/SjzMjQ1JHv9rV9eKEKic7/FcxA1TLAW9Sejx7tg
         MHQrS6mCOpcaUOiOLzvHSuZkKM5L/3pZwEEFNl/Dc96Wbln0Oa+7pWl6dmUlAOE1q4uV
         ayu4+N900yfydqYewMIe8mYYdNNqgVthCoHHtszUoAg+D6WAEXoF7uH0Zw4KSHfRem9E
         aPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794345301; x=1794950101;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nVARVyMM/7IfHWnXWeKDkhlyad2D80c3nx61nuy3dUo=;
        b=ZA67Vqo/5tL12tK5lAP9WbnOIKv8751v7a8VVZ7TDjs0vQZz5gF9TmqjkVho23bDcS
         NQ1VOHot5zjzZ7OLYe0qS5VEyf/TbVSyIDp3i/Lm2DXI3cWwhEDDmPgz8T4w6zNFfdJc
         pXn5nBTgvclTktKBKcpt7uc7sw5p443oyE2zJysd2v21IiSVaG7PbU5iI8pJxQRLNln9
         uBzQNugLM2SoOjMbZmvJJdoEyusQGAlZmcvrayCVC8fbp3e3LG7qPKkFjAhGkCJrwncI
         nzy+B+kRL3ycjSW0uOvzxBHi1wLSMvEHPGdaiXPs+fK+1AzkyDOOqvKMTaE/vO7Dzfx4
         7bGg==
X-Forwarded-Encrypted: i=1; AL+hErEp/HFnDJ/bst4FBxgWSq/o3rOmTL8Xtb6Y94WiAUJcZFJIvneDplz9UeCcx61zyBGlC/jmi1R4OSo17w==@vger.kernel.org
X-Gm-Message-State: APuU4Z/l8nsx0wAg60RDp+nb7Ri/RjpsGH94UlqHI8iLiIqYd1nh943+
	xLyaPhRHJw+UnUxoUTqFc/UxrmP6n0f6aU5LxMH6DUowsydRPLrnwcptATa0xqm00eo=
X-Gm-Gg: AYBFou3lAXZwd3SWIVJvMXhcWT2MOhUp9wcYzQgcL243PQ0WBUSTtPzXWa42YLeIBCX
	u9xmwm45R+O1Bwseop9SVkaOhii6MIlByDPis5S/rf1NqYfCTtImGaL9A6HozzGRe0iLDvef+SR
	T5O/hqfdOID1nhQBKd/rb6gM/xSpo/6nrd+F+Rd0MzTm1yGjZrFAuoXJHJbR3nCXM8ayKThCwtl
	HRi0Q632YROwVSPdHm4i70kfre97WUqhI1hJIqzo/XAFhkf5lURl1+SUlNfxFR+cEkx0OYtQchr
	vxy4DFT8VqbeCDAZVWiaR7oaBRJbVFApu1A+acKAyarQsELK7/A22Pi+BJI0305mxAQNcc4QTLH
	ZWJpCPzkEQkkaorC9UDK0eUL7tLQk0ly1BJETt8I0kkN5sZ4wO86Svk8QGc38MLvDY2qc8C5caL
	WRDLh+dHQpThMRt4LEgU2ZUwgbejbOyULz7BKWy+MWtmqUgIs/H5HSpd53d10cXCBiQX1EVkAKT
	DaMUETihPa4YZgaB8kw3HIk1pYosRDJ++tfSdMp3CAadpNCXqR5wTRlaUTEL31Mu5oeohEzoHme
	Cp93JKCgtWTAtL0KFkfpcA==
X-Received: by 2002:a05:600c:190a:b0:4a1:f99e:f22d with SMTP id 5b1f17b1804b1-4ba0936c0d2mr6059685e9.6.1794345300628;
        Tue, 10 Nov 2026 13:15:00 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17e51de3esm1157388a91.17.2026.11.10.13.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 13:14:59 -0800 (PST)
Message-ID: <04ce4048-ed7c-4de3-9224-a3e2a9fdd867@suse.com>
Date: Wed, 11 Nov 2026 07:44:53 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] btrfs: wait for ordered extent IO in fast fsync
To: Filipe Manana <fdmanana@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Boris Burkov
 <boris@bur.io>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
 <20261103-b4-btrfs-data-integrity-v2-3-577dc2690061@toxicpanda.com>
 <CAL3q7H6B9=fL2_Lx5OzWLRtFXNqfgnTn=kCf4NnE8JktuhSDKw@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <CAL3q7H6B9=fL2_Lx5OzWLRtFXNqfgnTn=kCf4NnE8JktuhSDKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/4 04:40, Filipe Manana 写道:
> On Tue, Nov 3, 2026 at 3:57 PM Josef Bacik <josef@toxicpanda.com> wrote:
>>
>> A fast fsync waits for writeback and then checks
>> BTRFS_INODE_COW_WRITE_ERROR to see whether a COW write failed. If one
>> did, it must wait for the ordered extents to complete before logging,
>> since until then the extent maps of the failed range point to extents
>> that were never written. Logging them puts unwritten extents in place
>> of the data that was there before when the log is replayed.
>>
>> The flag can be set too late for that check. end_bbio_data_write()
>> clears writeback before it finishes the ordered extent:
>>
>>    end_bbio_data_write()            fsync
>>
>>    btrfs_folio_clear_writeback()
>>                                     filemap_fdatawait_range()
>>                                     BTRFS_INODE_COW_WRITE_ERROR clear
>>                                     btrfs_log_changed_extents()
>>    btrfs_finish_ordered_extent()
>>      set BTRFS_INODE_COW_WRITE_ERROR
>>
>> The write paths that fail before submitting a bio, writepage_delalloc()
>> and submit_write_sector(), clear writeback and finish the ordered
>> extent through btrfs_mark_ordered_io_finished(), which never sets the
>> flag at all.
>>
>> Fix by dropping the flag and having a fast fsync wait for
>> BTRFS_ORDERED_IO_DONE on the ordered extents it collected for logging.
>> can_finish_ordered_extent() sets it only after recording any error with
>> BTRFS_ORDERED_IOERR. The wait costs little, because IO_DONE is set
>> right after writeback is cleared, not when the ordered extent completes.
>>
>> Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents after a write failure")
>> Fixes: a11d6912fdd9 ("btrfs: remove folio parameter from ordered io related functions")

In fact, if we merge this one, it will also fix the encoded write bug.

I think if we go this path, I can revert the fix of "btrfs: skip fast 
sync for inodes with encoded writes".

Thanks,
Qu

>> CC: stable@vger.kernel.org # 6.10+
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> The idea looks sound to me.
> 
> Sashiko found something and from a quick glance it seems valid to me:
> 
> https://sashiko.dev/#/patchset/20261103-b4-btrfs-data-integrity-v2-0-577dc2690061%40toxicpanda.com
> 
> Thanks.
> 
> 
>> ---
>>   fs/btrfs/btrfs_inode.h  | 10 ----------
>>   fs/btrfs/file.c         | 52 +++++++++++++++++++++++++++++++++++++++----------
>>   fs/btrfs/ordered-data.c | 31 -----------------------------
>>   3 files changed, 42 insertions(+), 51 deletions(-)
>>
>> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
>> index f7aa0d145185..65ba8ec23258 100644
>> --- a/fs/btrfs/btrfs_inode.h
>> +++ b/fs/btrfs/btrfs_inode.h
>> @@ -89,16 +89,6 @@ enum {
>>          BTRFS_INODE_FREE_SPACE_INODE,
>>          /* Set when there are no capabilities in XATTs for the inode. */
>>          BTRFS_INODE_NO_CAP_XATTR,
>> -       /*
>> -        * Set if an error happened when doing a COW write before submitting a
>> -        * bio or during writeback. Used for both buffered writes and direct IO
>> -        * writes. This is to signal a fast fsync that it has to wait for
>> -        * ordered extents to complete and therefore not log extent maps that
>> -        * point to unwritten extents (when an ordered extent completes and it
>> -        * has the BTRFS_ORDERED_IOERR flag set, it drops extent maps in its
>> -        * range).
>> -        */
>> -       BTRFS_INODE_COW_WRITE_ERROR,
>>          /*
>>           * Set by reflink while it holds the source's VFS inode lock shared.
>>           * Direct IO writes also take that lock shared; one that finds this bit
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index f978c6524aa0..4ae9aed8993f 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1512,6 +1512,42 @@ static inline bool skip_inode_logging(const struct btrfs_log_ctx *ctx)
>>          return false;
>>   }
>>
>> +/*
>> + * Wait for the IO of the ordered extents collected for logging to be done, and
>> + * return true if a COW write among them failed.
>> + *
>> + * Waiting for writeback is not enough to know that: the end IO handlers clear
>> + * writeback before they account the IO in the ordered extent. An ordered
>> + * extent gets BTRFS_ORDERED_IO_DONE only once all of its IO is accounted, and
>> + * can_finish_ordered_extent() sets BTRFS_ORDERED_IOERR before that.
>> + */
>> +static bool cow_write_failed(struct btrfs_inode *inode,
>> +                            struct list_head *ordered_extents)
>> +{
>> +       struct btrfs_ordered_extent *ordered;
>> +       bool failed = false;
>> +
>> +       list_for_each_entry(ordered, ordered_extents, log_list)
>> +               wait_event(ordered->wait,
>> +                          test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags));
>> +
>> +       /*
>> +        * can_finish_ordered_extent() records a write error before it sets
>> +        * BTRFS_ORDERED_IO_DONE, both under this lock.
>> +        */
>> +       spin_lock(&inode->ordered_tree_lock);
>> +       list_for_each_entry(ordered, ordered_extents, log_list) {
>> +               if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags) &&
>> +                   !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
>> +                       failed = true;
>> +                       break;
>> +               }
>> +       }
>> +       spin_unlock(&inode->ordered_tree_lock);
>> +
>> +       return failed;
>> +}
>> +
>>   /*
>>    * fsync call for both files and directories.  This logs the inode into
>>    * the tree log instead of forcing full commits whenever possible.
>> @@ -1615,7 +1651,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>>           * IO of a lower priority task while holding a transaction open.
>>           *
>>           * For a full fsync we wait for the ordered extents to complete while
>> -        * for a fast fsync we wait just for writeback to complete, and then
>> +        * for a fast fsync we wait just for their IO to complete, and then
>>           * attach the ordered extents to the transaction so that a transaction
>>           * commit waits for their completion, to avoid data loss if we fsync,
>>           * the current transaction commits before the ordered extents complete
>> @@ -1627,7 +1663,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>>           */
>>          if (full_sync || btrfs_is_zoned(fs_info)) {
>>                  ret = btrfs_wait_ordered_range(inode, start, len);
>> -               clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
>>          } else {
>>                  /*
>>                   * Get our ordered extents as soon as possible to avoid doing
>> @@ -1640,15 +1675,12 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>>                          goto out_release_extents;
>>
>>                  /*
>> -                * Check and clear the BTRFS_INODE_COW_WRITE_ERROR now after
>> -                * starting and waiting for writeback, because for buffered IO
>> -                * it may have been set during the end IO callback
>> -                * (end_bbio_data_write() -> btrfs_finish_ordered_extent()) in
>> -                * case an error happened and we need to wait for ordered
>> -                * extents to complete so that any extent maps that point to
>> -                * unwritten locations are dropped and we don't log them.
>> +                * If a COW write failed, before submitting a bio or during IO,
>> +                * the extent maps of its range point to unwritten locations
>> +                * until the ordered extent completes and drops them. Wait for
>> +                * that, so that we don't log them.
>>                   */
>> -               if (test_and_clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags))
>> +               if (cow_write_failed(inode, &ctx.ordered_extents))
>>                          ret = btrfs_wait_ordered_range(inode, start, len);
>>          }
>>
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>> index df74c75d6c29..27aca31866fd 100644
>> --- a/fs/btrfs/ordered-data.c
>> +++ b/fs/btrfs/ordered-data.c
>> @@ -436,37 +436,6 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>>                                          uptodate);
>>          spin_unlock(&inode->ordered_tree_lock);
>>
>> -       /*
>> -        * If this is a COW write it means we created new extent maps for the
>> -        * range and they point to unwritten locations if we got an error either
>> -        * before submitting a bio or during IO.
>> -        *
>> -        * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
>> -        * are queuing its completion below. During completion, at
>> -        * btrfs_finish_one_ordered(), we will drop the extent maps for the
>> -        * unwritten extents.
>> -        *
>> -        * However because completion runs in a work queue we can end up having
>> -        * a fast fsync running before that. In the case of direct IO, once we
>> -        * unlock the inode the fsync might start, and we queue the completion
>> -        * before unlocking the inode. In the case of buffered IO when writeback
>> -        * finishes (end_bbio_data_write()) we queue the completion, so if the
>> -        * writeback was triggered by a fast fsync, the fsync might start
>> -        * logging before ordered extent completion runs in the work queue.
>> -        *
>> -        * The fast fsync will log file extent items based on the extent maps it
>> -        * finds, so if by the time it collects extent maps the ordered extent
>> -        * completion didn't happen yet, it will log file extent items that
>> -        * point to unwritten extents, resulting in a corruption if a crash
>> -        * happens and the log tree is replayed. Note that a fast fsync does not
>> -        * wait for completion of ordered extents in order to reduce latency.
>> -        *
>> -        * Set a flag in the inode so that the next fast fsync will wait for
>> -        * ordered extents to complete before starting to log.
>> -        */
>> -       if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
>> -               set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
>> -
>>          if (ret)
>>                  btrfs_queue_ordered_fn(ordered);
>>   }
>>
>> --
>> 2.55.0
>>
>>

