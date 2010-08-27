From: James Smith <smithjd15@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Thu, 26 Aug 2010 21:38:11 -0600
Message-ID: <AANLkTimU1jEKYSBLTn_tD9G9=5jOFZ32k1Anmp5KUsDn@mail.gmail.com>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>
	<AANLkTik=t4mWvSOzLbFR3M7RbxgS=9WAFraj3XUguMLF@mail.gmail.com>
	<AANLkTinrujaWqN8NLNdaydL=ENOrMEgb9cjWdDD_g6GT@mail.gmail.com>
	<201008211137.12565.kreijack@libero.it>
	<AANLkTikJd8bDU1Eq22u0+yQ8eBCUn3OXHoE5E7uy+SG=@mail.gmail.com>
	<AANLkTi=VpZv26jntJ8mwmxtjnQ5LDOn_MSm6VtEhJ1CB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd32c361011b2048ec5d810
To: linux-btrfs@vger.kernel.org, kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=VpZv26jntJ8mwmxtjnQ5LDOn_MSm6VtEhJ1CB@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--000e0cd32c361011b2048ec5d810
Content-Type: text/plain; charset=ISO-8859-1

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index e112902..271ca89 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -497,7 +497,7 @@ static void print_one_uuid(struct btrfs_fs_devices
*fs_devices)
                devs_found++;
        }
        if (devs_found < total) {
-               printf("\t*** Some devices missing\n");
+               printf("\t L1: Some devices missing\n");
        }
        printf("\n");
 }


diff --git a/btrfs.c b/btrfs.c
index 4d263c4..b3a087e 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -134,12 +135,13 @@ static void help(char *np)
 {
        struct Command *cp;

-       printf("Usage:\n");
+       printf("VFS-2593-A %s\n", BTRFS_BUILD_VERSION);
+       printf("\nNo matter where you go, there you are.\n");
+       printf("\nUsage:\n");
        for( cp = commands; cp->verb; cp++ )
                print_help(np, cp);

-       printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
-       printf("\n%s\n", BTRFS_BUILD_VERSION);
+       printf("\n\t%s help|--help|-h\n\t\tShow help.\n",np);
 }



I don't like the look of using errno.h at this time, so attached is
the error code file extracted from the help file and an additional
patch for label support. There may be leftover typos especially in the
errorcode.txt file so it might be nice to have a read-over. Does
someone want to get on strings translation? :)


On 8/21/10, James Smith <smithjd15@gmail.com> wrote:
> excuse me, errno.h.
>
> On 8/21/10, James Smith <smithjd15@gmail.com> wrote:
>> Thanks.
>>
>> What about stderr.h?
>>
>> On 8/21/10, Goffredo Baroncelli <kreijack@gmail.com> wrote:
>>> On Saturday, 21 August, 2010, James Smith wrote:
>>> [...]
>>>> I'll look at a error.txt file (after finding convention) and also
>>>> update the man. In regards to shortening of dev/device -- is this
>>>> really neccessary? And what harm does this cause in the first place?
>>>> In device add-delete functionality.
>>>
>>> Make sense to rename <dev> in <device> for the "btrfs add/delete"
>>> commands
>>>
>>>
>>>>
>>>>
>>>> On 8/20/10, Josh Berry <des@condordes.net> wrote:
>>>> > On Fri, Aug 20, 2010 at 12:00, Andreas Philipp
>>>> > <philipp.andreas@gmail.com> wrote:
>>>> >>  On 20.08.2010 20:49, Josh Berry wrote:
>>>> >>>
>>>> >>> On Fri, Aug 20, 2010 at 11:34, Andreas Philipp
>>>> >>> <philipp.andreas@gmail.com>  wrote:
>>>> >>>>
>>>> >>>>  On 20.08.2010 20:27, Josh Berry wrote:
>>>> >>>>>
>>>> >>>>> On Fri, Aug 20, 2010 at 05:03, Goffredo
>>> Baroncelli<kreijack@gmail.com>
>>>> >>>>>  wrote:
>>>> >>>>>>
>>>> >>>>>> On Thursday, 19 August, 2010, James Smith wrote:
>>>> >>>>>>>
>>>> >>>>>>> This patch randomizes the error codes and also fixes up some
>>>> >>>>>>> typos
>>>> >>>>>>
>>>> >>>>>> including
>>>> >>>>>>>
>>>> >>>>>>> capitalization in the output.
>>>> >>>>>>>
>>>> >>>>>>> It would almost be nice to see a translation effort for the
>>>> >>>>>>> tool
>>>> >>>>>>> as
>>>> >>>>>>> well.
>>>> >>>>>
>>>> >>>>> [...]
>>>> >>>>>>
>>>> >>>>>> +                       fprintf(stderr, "ERR-A.11: in command
>>>> >>>>>> '");
>>>> >>>>>>
>>>> >>>>>> I am not against this kind of error codes, but I prefer
>>>> >>>>>>
>>>> >>>>>> +                       fprintf(stderr, "Error 'ERR-A.11' in
>>>> >>>>>> command
>>>> >>>>>> '");
>>>> >>>>>
>>>> >>>>> As a layman/end user, I disagree.  The former format is easier
>>>> >>>>> for
>>>> >>>>> shell scripts and the like to parse -- the error code can be
>>> extracted
>>>> >>>>> with a simple "cut -d: -f1".
>>>> >>>>
>>>> >>>> This makes no difference. A simple `cut -d " " -f1` would do the
>>>> >>>> job
>>> in
>>>> >>>> the
>>>> >>>> second case.
>>>> >>>
>>>> >>> I think you meant -f2, and that still leaves the quotes hanging
>>>> >>> around.  So you'd need to cut -d" " -f2 |tr -d "'" .  It's not a
>>>> >>> big
>>>> >>> deal either way, I just think the former is easier to work with.
>>>> >>
>>>> >> Sorry, of course -f2. But why not simply cut -d "'" -f 2?
>>>> >
>>>> > Oh right, good point. :)  Though as Goffredo said, using the error
>>>> > code is probably better anyway.
>>>> >
>>>> > -- Josh
>>>> > --
>>>> > To unsubscribe from this list: send the line "unsubscribe
>>>> > linux-btrfs"
>>>> > in
>>>> > the body of a message to majordomo@vger.kernel.org
>>>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> >
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>> --
>>> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo)
>>> <kreijack@inwind.it>
>>> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>

--000e0cd32c361011b2048ec5d810
Content-Type: text/plain; charset=US-ASCII; name="errorcodes.txt"
Content-Disposition: attachment; filename="errorcodes.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RXJyb3IgY29kZSBsaXN0aW5nIGZvciBidHJmcy4KCkEpIENsb25lIGJ0cmZzIGRpc2sKQTE6IEVy
cm9yIGFjY2Vzc2luZyB0aGUgaW5wdXR0ZWQgc3Vidm9sdW1lLgpBMjogVGhlIGlucHV0dGVkIHN1
YnZvbHVtZSBpcyBub3QgcmVjb2duaXplZCBhcyBhIHN1YnZvbHVtZS4KQTM6IFBhc3NlZCBhcmd1
bWVudCBpcyBub3QgYSBkaXJlY3RvcnkuCgpCKSBTbmFwc2hvdCBidHJmcyBkaXNrCkIxOiBJbmNv
cnJlY3Qgc25hcHNob3QgbmFtZSBoYXMgYmVlbiBlbnRlcmVkLgpCMjogSW5wdXR0ZWQgbmFtZSBp
cyBwYXN0IHRoZSBhbGxvd2VkIGxlbmd0aC4KQjM6IENhbm5vdCBhY2Nlc3MgYSByZXF1ZXN0ZWQg
ZmlsZS4KQjQ6IENhbm5vdCBhY2Nlc3MgcmVxdWVzdGVkIGZpbGUuCkI1OiBDYW5ub3Qgc25hcHNo
b3QgZGlzay4KCkMpIERlbGV0ZSBzdWJ2b2x1bWUKQzE6IEVycm9yIGRlbGV0aW5nIHRoZSBpbnB1
dHRlZCBzdWJ2b2x1bWUuCkMyOiBDYW5ub3QgZGVsZXRlIHRoZSBtYXJrZWQgZmlsZS4gKElzIG5v
dCBhIHN1YnZvbHVtZSkKQzM6IEluY29ycmVjdCBzdWJ2b2x1bWUgbmFtZS4KQzQ6IElucHV0dGVk
IG5hbWUgaXMgcGFzdCB0aGUgYWxsb3dlZCBsZW5ndGguIChNYXggY2hhcjogMjU1KQpDNTogQ2Fu
bm90IGFjY2VzcyB0aGUgc3Vidm9sdW1lIGZvciBkZWxldGlvbi4KQzY6IENhbm5vdCBkZWxldGUg
c3Vidm9sdW1lLgoKRCkgQ3JlYXRlIHN1YnZvbHVtZQpEMTogSW5wdXR0ZWQgbmFtZSBhbHJlYWR5
IGV4aXN0cy4KRDI6IEluY29ycmVjdCBzdWJ2b2x1bWUgbmFtZSBoYXMgYmVlbiBlbnRlcmVkSSkg
QWRkIFZvbHVtZSB0byBmaWxlc3lzdGVtLgpJMTogQ2FuJ3QgYWNjZXNzIG1vdW50IHBvaW50IHBv
aW50IGZvciBhZGRpbmcgdm9sdW1lLgpJMjogVW5hYmxlIHRvIG9wZW4gZGV2aWNlIGZvciBhZGRp
bmcgdm9sdW1lLgpJMzogVW5hYmxlIHRvIHN0YXQuLgpEMzogSW5wdXR0ZWQgbmFtZSBpcyBwYXN0
IHRoZSBhbGxvd2VkIGxlbmd0aC4gKE1heCBjaGFyOiAyNTUpCkQ0OiBDYW5ub3QgYWNjZXNzIHJl
cXVlc3RlZCBmaWxlLgpENTogQ2Fubm90IGNyZWF0ZSBzdWJ2b2x1bWUuCkQ2OiBDYW5ub3QgYWNj
ZXNzIGZvciBzeW5jaW5nLgpENzogVW5hYmxlIHRvIGNyZWF0ZSBzeW5jLgoKRSkgU2NhbiBmb3Ig
YnRyZnMgZmlsZXN5c3RlbXMgb24gYmxvY2sgZGV2aWNlLgpFMTogRXJyb3Igc2Nhbm5pbmcgZm9y
IGJ0cmZzIGZpbGVzeXN0ZW0uCkUyOiBGYWlsZWQgdG8gb3BlbiBkZXYgbm9kZSB0byBpbml0aWFs
aXplIGZpbGVzeXN0ZW0gdG9vbC4KRTM6IFVuYWJsZSB0byBzY2FuIHRoZSBkZXZpY2UuCgpGKSBE
ZWZyYWdtZW50CkYxOiBDYW5ub3QgYWNjZXNzIHRoZSBkZXZpY2UgdG8gY29tcGxldGUgYSBkZWZy
YWdtZW50LgpGMjogVW5hYmxlIHRvIGRlZnJhZ21lbnQgaW5wdXR0ZWQgZGV2aWNlLgoKRykgUmVz
aXplIApHMTogQ2Fubm90IGFjY2VzcyBkZXZpY2Ugbm9kZSBmb3IgcmVzaXplIGNvbXBsZXRpb24u
CkcyOiBTaXplIHZhbHVlIHRvbyBsb25nIHRvIGFsbG93IHJlc2l6ZS4KRzM6IFVuYWJsZSB0byBy
ZXNpemUgYnRyZnMgcGFydGl0aW9uLiAKCkgpIFNjYW4gZmlsZXN5c3RlbQpIMTogRXJyb3Igd2hp
bGUgc2Nhbm5pbmcuCgpJKSBBZGQgVm9sdW1lIHRvIGZpbGVzeXN0ZW0uCkkxOiBDYW4ndCBhY2Nl
c3MgbW91bnQgcG9pbnQgcG9pbnQgZm9yIGFkZGluZyB2b2x1bWUuCkkyOiBVbmFibGUgdG8gb3Bl
biBkZXZpY2UgZm9yIGFkZGluZyB2b2x1bWUuCkkzOiBVbmFibGUgdG8gc3RhdC4KSTQ6IE5vdCBh
IGJsb2NrIGRldmljZS4KSTU6IFVuYWJsZSB0byBpbml0IGRldmljZSBmb3IgYWRkaW5nIG9mIHZv
bHVtZXMuCkk2OiBFcnJvciBhZGRpbmcgdGhlIGRldmljZSBmb3IgYWRkaW5nIHZvbHVtZXMuCgpK
KSBCYWxhbmNpbmcgZmlsZXN5c3RlbXMuCkoxOiBDYW5ub3QgYWNjZXNzIHJlcXVlc3RlZCBmaWxl
cy4KSjI6IEJhbGFuY2luZyBpbm9kZXMuCgpLKSBSZW1vdmUgVm9sdW1lIGZyb20gZmlsZXN5c3Rl
bS4KSzE6IENhbm5vdCBhZGRlc3MgcmVxdWVzdGVkIGZpbGUgZm9yIHZvbHVtZSByZW1vdmFsLgpL
MjogRXJyb3IgcmVtb3ZpbmcgdGhlIGRldmljZS4KCkwpIExhYmVsCkwxOiBTb21lIGRldmljZXMg
bWlzc2luZy4KCgo9PT0KQS4xMSkgQW1iaWd1b3VzIGFyZ3VtZW50CkIuMTIpIFVua25vd24gQ29t
bWFuZApDLjEzKSBNaW5pbXVtIGFyZ3VtZW50cyB1bnNhdGlzZmllZApELjE0KSBNaW5pbXVtIGFy
Z3VtZW50cyB1bnNhdGlzZmllZA==
--000e0cd32c361011b2048ec5d810--
