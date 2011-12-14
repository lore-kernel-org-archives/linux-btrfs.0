From: Wilfred van Velzen <wvvelzen@gmail.com>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Wed, 14 Dec 2011 19:51:58 +0100
Message-ID: <CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
	<CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 7:21 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Wed, Dec 14, 2011 at 7:00 AM, Wilfred van Velzen <wvvelzen@gmail.c=
om> wrote:
>>
>> What is best practice when partitioning a device that holds one or
>> more btr-filesystems
>>
>
> When it comes to "best practices" in btrfs filesystem layouts, your
> primary consideration should be to make yourself robust to potential
> filesystem failure.
>
> Of course this should be true of any storage arrangement.
>
> But if you're going to be playing with rc kernels and applying patche=
s
> off the list, you might want to break it up into multiple partitions
> so as to mitigate the problem if one partition picks up a
> inconsistency.
>
> On the other hand, it's also good for people to use the volume and
> subvolume features. =A0There's many different ways for people to make
> use of volumes and subvolumes, and it's good to explore those
> features.

Well, of course there are different usecases for different situations.

What I want to find out is, if you should partition differently when
you are using btrfs compared to partitioning for the other
older/regular filesystems for linux, for regular (production)
usecases.

(I'm not interested in what early adopter users do when they are using
rc kernels...)

http://btrfs.ipv5.de/index.php?title=3DUseCases#What_is_best_practice_w=
hen_partitioning_a_device_that_holds_one_or_more_btr-filesystems

--=20
Wilfred.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
