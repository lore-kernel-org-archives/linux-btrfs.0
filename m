From: Peeters Simon <peeters.simon@gmail.com>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Wed, 14 Dec 2011 17:43:55 +0100
Message-ID: <CAKyAS7tVcMreGVr0bt-Q8Q-d8s12UxJuAiPH7yiTrWjp6SPgmA@mail.gmail.com>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Wilfred van Velzen <wvvelzen@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/14 Wilfred van Velzen <wvvelzen@gmail.com>:
> Hi,
>
> What is best practice when partitioning a device that holds one or
> more btr-filesystems
>
> Do it the old fashioned way, and create a number of partitions
> according to your needs? Or create one big btrfs partition and use
> subvolumes where you would normally create different partitions?
>
> What are the considerations for doing it either way?
>

it depends,

Currently I am using the old fashioned setup becouse of a couple of reasons:
* I converted some of them from ext4
* Selecting the right subvolume to boot from is not easy (i know it is
posible, but have not yet got the time to look into it deep enough)
* If one of the filesystems gets destroyed due too a btrfs bug, i
still have the other ones (I have currently "/", "/home" and a backup
of "/home" which is never automounted)


Simon
