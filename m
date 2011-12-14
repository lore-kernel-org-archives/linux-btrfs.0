From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: What is best practice when partitioning a device that holds one or more btr-filesystems
Date: 14 Dec 2011 14:17:00 +0100
Message-ID: <BzrzxoPy1uB@helmut.hullen.de>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Wilfred,

Du meintest am 14.12.11:

> What is best practice when partitioning a device that holds one or
> more btr-filesystems

"That depends ..."

My favourite installation is a bundle of 2-TByte-disks which btrfs  
presents as one big disk. data=raid0, metadata=raid1

It's a kind of archive, p.e. for video *.mpeg

Viele Gruesse!
Helmut
