From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v3] Re: btrfs does not work on usermode linux
Date: Mon, 11 Apr 2011 15:50:48 -0400
Message-ID: <4DA35B98.3010800@redhat.com>
References: <20110410133710.0ef34cb6@sf>	<20110410184249.483d8d67@sf>	<20110410230622.09e965ae@sf>	<20110410232403.617c3b7f@sf>	<20110410235846.135e801e@sf>	<4DA32055.2030104@redhat.com> <20110411224452.4a5149da@sf>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	cwillu <cwillu@cwillu.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110411224452.4a5149da@sf>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/11/2011 03:44 PM, Sergei Trofimovich wrote:
>> Fix data corruption caused by memcpy() usage on overlapping data.
>> I've observed it first when found out usermode linux crash on btrfs.
>
> Changes since v2:
> - Code style cleanup
> - 2 versions of patch: BUG_ON and WARN_ON variants,
>    _but_ see below why I prefer BUG_ON
>
> Changes since v1:
>
>>   	else
>>   		src_kaddr = dst_kaddr;
>>
>> +	BUG_ON(abs(src_off - dst_off)<  len);
>>   	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
>
> Too eager BUG_ON. Now used only for src_page == dst_page.
>
>> -	if (dst_offset<  src_offset) {
>> +	if (abs(dst_offset - src_offset)>= len) {
>
> abs() is not a good thing to use un unsigned values. aded helper overlapping_areas.
>
> On Mon, 11 Apr 2011 11:37:57 -0400
> Josef Bacik<josef@redhat.com>  wrote:
>
>> +	{
>> you will want to turn that into
>>
>> if (dst_page != src_page) {
>
> done
>
>> Also maybe BUG_ON() is a little strong, since the kernel will do this
>> right, it just screws up UML.  So maybe just do a WARN_ON() so we notice
>> it.  Thanks,
>
> I'm afaid I didn't understand this part. The commit I've found a deviation
> was linux's implementation of memcpy (UML uses it as kernel does). Why the
> kernel differs to UML in that respect? Seems I don't know/understand something
> fundamental here.
> So, if data overlaps - it's a moment before data corruption, thus BUG_ON.
>
> Another thought is (if memcpy semantics differ from standard C's function):
> does linux's memcpy guarantee copying direction behaviour?
> If it does, then it's really a weird memmove and x86/memcpy_64.S is a bit broken.
>
> Attached both patches, I personally like BUG_ON variant.
> Pick the one you like more :]
>
> Thanks for the feedback!
>

Fair enough, BUG_ON() it is.  Repost that version and you can add my

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
