From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Inefficient storing of ISO images with compress=lzo
Date: Mon, 19 Sep 2011 11:13:19 +0800
Message-ID: <4E76B34F.9030206@cn.fujitsu.com>
References: <1316388769.2499.4.camel@picard> <4E76AEB9.4080109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: uzytkownik2@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E76AEB9.4080109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan wrote:
> Maciej Marcin Piechotka wrote:
>> I've noticed that:
>>
>>  - with x86-64 Fedora 15 DVD install images:
>>    - du -sh <ROOT VOLUME> was 36 GB
>>    - btrfs df | grep -i data have shown over 40 GB used
>>  - without
>>    - du -sh <ROOT VOLUME> is 34 GB
>>    - btrfs df | grep -i data have shown less then 34 GB used
>>
>> It seems that iso files are considered compressable while they may not be (and penalty is severe - 3x).
>>
> 
> With compress option specified, btrfs will try to compress the file, at most
> 128K at one time, and if the compressed result is not smaller, the file will
> be marked as uncompressable.
> 
> I just tried with Fedora-14-i386-DVD.iso, and the first 896K is compressed,
> with a compress ratio about 71.7%, and the remaining data is not compressed.
> 

correct: the compression ratio is 38.3%, pretty good :)
