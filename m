From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Subject: btrfsck segmentation fault
Date: Sat, 16 Jan 2010 23:27:56 -0200
Message-ID: <b8bf37781001161727vc023a93u529aa4bf1fd1cdc3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

     when trying to btrfsck my filesystem, I got the following error:

# btrfsck /dev/sda7
parent transid verify failed on 13785038848 wanted 45848 found 45839
Segmentation fault

    Crash occurs at extent-tree.c:find_first_block_group when it gets:

                leaf =3D path->nodes[0];

    after that btrfs_header_nritems dereferences the leaf unconditional=
ly:

        struct btrfs_header *h =3D (struct btrfs_header *)leaf->data;

    Any thoughts on how to make it succeed?

Thank you,
Andr=E9
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
