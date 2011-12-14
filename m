From: Wilfred van Velzen <wvvelzen@gmail.com>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Wed, 14 Dec 2011 22:42:18 +0100
Message-ID: <CAKsPgxEk8+WJ2dGpzO4WG=UcO9y8j6j_5nX4c5x6H=qbjVVAJw@mail.gmail.com>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
	<CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com>
	<CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com>
	<CA+WRLO98Je2J1SMZv0zVi1r1AfGFcnUCHKU=sJAsYDuUssqx8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+WRLO98Je2J1SMZv0zVi1r1AfGFcnUCHKU=sJAsYDuUssqx8w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 9:56 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> On Thu, Dec 15, 2011 at 5:51 AM, Wilfred van Velzen <wvvelzen@gmail.com>
> wrote:
>>
>> (I'm not interested in what early adopter users do when they are using
>> rc kernels...)
>
> Yet your going to use a FS without a working fsck? That puts you in early
> adopter territory to me.

Yeah maybe. But I'm still not interested in it regarding partitioning! ;)

But actually I decided not to use it for the production environment.
The missing working fsck is one of the reasons.
Although opensuse supports it and Suse Linux Enterprise Server 11 is
going to support it with their next SP release in Februari, and Fedora
might use it as default in their next release... Did I miss any?

But I'm going to use it at home and probably in some test environments rsn... ;)

Wilfred
