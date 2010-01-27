From: Liuwenyi <qingshenlwy@gmail.com>
Subject: Re: [PATCH]btrfs: avoid comparing with NULL pointer
Date: Wed, 27 Jan 2010 22:19:50 +0800
Message-ID: <4B604B86.9040307@gmail.com>
References: <4B5FDCD1.8060806@gmail.com> <3d0408631001270000w49fc9100yb1e3b59df2e032e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: chris.mason@oracle.com, jbacik@redhat.com, jens.axboe@oracle.com,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel@vger.kernel.org, strongzgy@gmail.com
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755253Ab0A0OUA@vger.kernel.org>
In-Reply-To: <3d0408631001270000w49fc9100yb1e3b59df2e032e9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

=E4=BA=8E 2010=E5=B9=B401=E6=9C=8827=E6=97=A5 16:00, Yan, Zheng =E5=86=99=
=E9=81=93:
> 2010/1/27 Liuwenyi<qingshenlwy@gmail.com>:
>   =20
>> In this patch, I adjust the seqence of if-conditions.
>> It will assess the page->private situation.
>> First, we make sure the page->private is not null.
>> And then, we can do some with this page->private.
>>
>> ---
>> Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
>> Cc: Chris Mason<chris.mason@oracle.com>
>> Cc: Yan Zheng<zheng.yan@oracle.com>
>> Cc: Josef Bacik<jbacik@redhat.com>
>> Cc: Jens Axboe<jens.axboe@oracle.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>>
>> ---
>> fs/btrfs/disk-io.c | 4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 009e3bd..a300dca 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1407,11 +1407,11 @@ static int bio_ready_for_csum(struct bio *bi=
o)
>>
>> bio_for_each_segment(bvec, bio, i) {
>> page =3D bvec->bv_page;
>> - if (page->private =3D=3D EXTENT_PAGE_PRIVATE) {
>> + if (!page->private) {
>> length +=3D bvec->bv_len;
>> continue;
>> }
>> - if (!page->private) {
>> + if (page->private =3D=3D EXTENT_PAGE_PRIVATE) {
>> length +=3D bvec->bv_len;
>> continue;
>> }
>> --
>>     =20
> Why do you want to do this? The code is perfect safe even
> page->private is NULL. Furthermore, your patch is malformed.
>
> Yan, Zheng
>   =20
Yes, I agree with you, this code is safe.
But I think we should check whether the pointer is available first.
It is unnecessary judge the "(page->private =3D=3D EXTENT_PAGE_PRIVATE)=
"
while page->private is null.


---
Best Regards,
Liuwenyi
2010-1-27
