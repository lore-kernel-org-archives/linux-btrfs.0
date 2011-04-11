From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] Re: btrfs does not work on usermode linux
Date: Mon, 11 Apr 2011 11:37:57 -0400
Message-ID: <4DA32055.2030104@redhat.com>
References: <20110410133710.0ef34cb6@sf>	<20110410184249.483d8d67@sf>	<20110410230622.09e965ae@sf>	<20110410232403.617c3b7f@sf> <20110410235846.135e801e@sf>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	cwillu <cwillu@cwillu.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110410235846.135e801e@sf>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/10/2011 04:58 PM, Sergei Trofimovich wrote:
> On Sun, 10 Apr 2011 23:24:03 +0300
> Sergei Trofimovich<slyich@gmail.com>  wrote:
>
>> Fix data corruption caused by memcpy() usage on overlapping data.
>> I've observed it first when found out usermode linux crash on btrfs.
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

Very nice catch, one nit


  	if (dst_page != src_page)
  		src_kaddr = kmap_atomic(src_page, KM_USER1);
  	else
+	{
  		src_kaddr = dst_kaddr;
+		BUG_ON(areas_overlap(src_off, dst_off, len));
+	}

you will want to turn that into

if (dst_page != src_page) {
	src_kaddr = kmap_atomic(src_page, KM_USER1);
} else {
	src_kaddr = dst_kaddr;
	BUG_ON(areas_overlap(src_off, dst_off, len));
}

Also maybe BUG_ON() is a little strong, since the kernel will do this 
right, it just screws up UML.  So maybe just do a WARN_ON() so we notice 
it.  Thanks,

Josef
