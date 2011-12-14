From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Thu, 15 Dec 2011 05:46:51 +0700
Message-ID: <CAG1y0seDMHaBXF5=ZW1pyrgTFEpKU+qcTN_MhR65eyUMzheHAg@mail.gmail.com>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
	<CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com>
	<CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com>
	<CA+WRLO98Je2J1SMZv0zVi1r1AfGFcnUCHKU=sJAsYDuUssqx8w@mail.gmail.com>
	<CAKsPgxEk8+WJ2dGpzO4WG=UcO9y8j6j_5nX4c5x6H=qbjVVAJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Wilfred van Velzen <wvvelzen@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKsPgxEk8+WJ2dGpzO4WG=UcO9y8j6j_5nX4c5x6H=qbjVVAJw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 15, 2011 at 4:42 AM, Wilfred van Velzen <wvvelzen@gmail.com> wrote:
> On Wed, Dec 14, 2011 at 9:56 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
>> On Thu, Dec 15, 2011 at 5:51 AM, Wilfred van Velzen <wvvelzen@gmail.com>
>> wrote:
>>>
>>> (I'm not interested in what early adopter users do when they are using
>>> rc kernels...)
>>
>> Yet your going to use a FS without a working fsck? That puts you in early
>> adopter territory to me.
>
> Yeah maybe. But I'm still not interested in it regarding partitioning! ;)

I'd just use one big partition. That way all subvolume can share free
space, making space use more efficient.

If you decide to go that route, the missing feature is quota and space
accounting. At this moment you can't tell which subvol use how much,
and limit it. There are (unmerged) patches for that though.

>
> But actually I decided not to use it for the production environment.
> The missing working fsck is one of the reasons.
> Although opensuse supports it and Suse Linux Enterprise Server 11 is
> going to support it with their next SP release in Februari, and Fedora
> might use it as default in their next release... Did I miss any?

Oracle linux :D

> But I'm going to use it at home and probably in some test environments rsn... ;)

If you're keeping your options open, try zfsonlinux as well. It might
be better suited for certain needs.

-- 
Fajar
