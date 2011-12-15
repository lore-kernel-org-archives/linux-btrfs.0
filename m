From: dima <dolenin@parallels.com>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Thu, 15 Dec 2011 17:29:12 +0900
Message-ID: <4EE9AFD8.1010306@parallels.com>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com> <CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com> <CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com> <4EE948AD.9040001@parallels.com> <20111215082543.GA12179@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111215082543.GA12179@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/15/2011 05:25 PM, Sander wrote:
> dima wrote (ao):
>> Maybe just skip partitioning altogether ;)
>
> +1
>
>> format the device to
>> btrfs and use subvolumes instead of your usual partitions (some
>> /boot restrictions apply). You won't be able to use grub2 though,
>> but syslinux will work.
>
> Grub2 has btrfs support for quite some time now, which you are aware of
> I assume. Grub2 can't cope with / in a subvolume or something?

No, btrfs has nothing to do with this. It is just that grub2 cannot be 
installed to a partition-less drive (at least 1 partition is needed), 
while syslinux can.
